package main

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"net/http/httptest"
	"strings"
	"sync"
	"testing"
	"time"

	"github.com/shurcooL/githubv4"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestIsStaleHeadConflict(t *testing.T) {
	tests := []struct {
		name string
		err  error
		want bool
	}{
		{"nil error", nil, false},
		{"real stale-head message", errors.New(`Expected branch to point to "abc123" but it did not. Pull and try again.`), true},
		{"message fragment, different casing", errors.New("EXPECTED BRANCH TO POINT TO something"), true},
		{"pull and try again fragment only", errors.New("some wrapper: pull and try again"), true},
		{"unrelated auth error", errors.New("401 Unauthorized: bad credentials"), false},
		{"unrelated not found error", errors.New("Could not resolve to a Repository with the name 'owner/repo'."), false},
		{"unrelated network error", errors.New("dial tcp: connection refused"), false},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			assert.Equal(t, tt.want, isStaleHeadConflict(tt.err))
		})
	}
}

const staleErrorBody = `{"errors":[{"message":"Expected branch to point to \"deadbeef\" but it did not. Pull and try again.","type":"STALE_DATA"}]}`

// mockGitHub is an httptest handler standing in for the GitHub GraphQL API. The
// createCommitOnBranch mutation returns a stale-head conflict for its first
// conflictsBeforeSuccess calls (or mutateErrBody forever, if set), then succeeds;
// the head-refresh query returns a fresh oid each time.
type mockGitHub struct {
	conflictsBeforeSuccess int
	mutateErrBody          string

	mu           sync.Mutex
	mutateCalls  int
	refreshCalls int
	mutateOids   []string // expectedHeadOid sent on each mutation, in order
}

func (g *mockGitHub) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	body, _ := io.ReadAll(r.Body)
	var env struct {
		Query     string `json:"query"`
		Variables struct {
			Input struct {
				ExpectedHeadOid string `json:"expectedHeadOid"`
			} `json:"input"`
		} `json:"variables"`
	}
	if err := json.Unmarshal(body, &env); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	g.mu.Lock()
	defer g.mu.Unlock()

	var resp string
	if strings.Contains(env.Query, "createCommitOnBranch") {
		g.mutateCalls++
		g.mutateOids = append(g.mutateOids, env.Variables.Input.ExpectedHeadOid)
		switch {
		case g.mutateErrBody != "":
			resp = g.mutateErrBody
		case g.mutateCalls <= g.conflictsBeforeSuccess:
			resp = staleErrorBody
		default:
			resp = `{"data":{"createCommitOnBranch":{"commit":{"url":"https://example.test/commit/final"}}}}`
		}
	} else {
		g.refreshCalls++
		resp = fmt.Sprintf(`{"data":{"repository":{"ref":{"target":{"oid":"refreshed-%d"}}}}}`, g.refreshCalls)
	}
	_, _ = io.WriteString(w, resp)
}

// newTestClient starts an httptest server backed by gh and returns a real
// githubv4 client pointed at it, so the tests exercise the actual request
// encoding and GraphQL error decoding rather than a hand-faked client.
func newTestClient(t *testing.T, gh *mockGitHub) *githubv4.Client {
	t.Helper()
	srv := httptest.NewServer(gh)
	t.Cleanup(srv.Close)
	return githubv4.NewEnterpriseClient(srv.URL, srv.Client())
}

func newTestInput() githubv4.CreateCommitOnBranchInput {
	return githubv4.CreateCommitOnBranchInput{
		Branch: githubv4.CommittableBranch{
			RepositoryNameWithOwner: githubv4.NewString("dash0hq/ghcommit"),
			BranchName:              githubv4.NewString("main"),
		},
		Message:         githubv4.CommitMessage{Headline: "test"},
		ExpectedHeadOid: githubv4.GitObjectID("original-oid"),
	}
}

func TestCommitWithRetry(t *testing.T) {
	t.Run("succeeds on first attempt without refreshing", func(t *testing.T) {
		gh := &mockGitHub{conflictsBeforeSuccess: 0}
		client := newTestClient(t, gh)

		url, err := commitWithRetry(context.Background(), client, "dash0hq/ghcommit", "main", newTestInput(), 0, time.Millisecond)

		require.NoError(t, err)
		assert.Equal(t, "https://example.test/commit/final", url)
		assert.Equal(t, 1, gh.mutateCalls)
		assert.Equal(t, 0, gh.refreshCalls)
	})

	t.Run("recovers within retries, refreshing the head each conflict", func(t *testing.T) {
		gh := &mockGitHub{conflictsBeforeSuccess: 2}
		client := newTestClient(t, gh)

		url, err := commitWithRetry(context.Background(), client, "dash0hq/ghcommit", "main", newTestInput(), 3, time.Millisecond)

		require.NoError(t, err)
		assert.Equal(t, "https://example.test/commit/final", url)
		assert.Equal(t, 3, gh.mutateCalls)
		assert.Equal(t, 2, gh.refreshCalls)
		// Each retry must carry the freshly-read head oid, not the stale one.
		assert.Equal(t, []string{"original-oid", "refreshed-1", "refreshed-2"}, gh.mutateOids)
	})

	t.Run("returns the conflict error when retries are exhausted", func(t *testing.T) {
		gh := &mockGitHub{conflictsBeforeSuccess: 100}
		client := newTestClient(t, gh)

		url, err := commitWithRetry(context.Background(), client, "dash0hq/ghcommit", "main", newTestInput(), 2, time.Millisecond)

		require.Error(t, err)
		assert.True(t, isStaleHeadConflict(err), "error should be the stale-head conflict, got: %v", err)
		assert.Empty(t, url)
		assert.Equal(t, 3, gh.mutateCalls) // initial attempt + 2 retries
	})

	t.Run("does not retry a non-conflict error", func(t *testing.T) {
		gh := &mockGitHub{mutateErrBody: `{"errors":[{"message":"Could not resolve to a Repository with the name 'x'."}]}`}
		client := newTestClient(t, gh)

		_, err := commitWithRetry(context.Background(), client, "dash0hq/ghcommit", "main", newTestInput(), 3, time.Millisecond)

		require.Error(t, err)
		assert.False(t, isStaleHeadConflict(err), "non-conflict error should not be treated as a stale-head conflict")
		assert.Equal(t, 1, gh.mutateCalls)
		assert.Equal(t, 0, gh.refreshCalls)
	})
}
