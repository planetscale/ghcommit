package main

import (
	"bytes"
	"context"
	"encoding/base64"
	"fmt"
	"io"
	"log"
	"os"
	"os/exec"
	"strings"
	"time"

	"github.com/cenkalti/backoff/v7"
	"github.com/jessevdk/go-flags"
	"github.com/shurcooL/githubv4"
	"golang.org/x/oauth2"
)

const githubGraphQLURL = "https://api.github.com/graphql"

var version = "development"

var opts struct {
	Adds       []string      `short:"a" long:"add" description:"Added or modified file to commit. Use multiple times for multiple files." env:"GHCOMMIT_ADD"`
	Deletes    []string      `short:"d" long:"delete" description:"Deleted file to commit. Use multiple times for multiple files." env:"GHCOMMIT_DELETE"`
	Empty      bool          `short:"e" long:"empty" description:"Allow empty commit." env:"GHCOMMIT_EMPTY"`
	Message    string        `short:"m" long:"message" description:"Commit message" env:"GHCOMMIT_MESSAGE" required:"true"`
	Repository string        `short:"r" long:"repository" description:"Owner/Repository to commit to." env:"GHCOMMIT_REPOSITORY" required:"true"`
	Branch     string        `short:"b" long:"branch" description:"Branch to commit to." env:"GHCOMMIT_BRANCH" required:"true"`
	HeadSHA    string        `short:"s" long:"sha" description:"Commit SHA of the HEAD branch to apply to. Acts as a safety check to ensure the right branch is modified. The output of 'git rev-parse HEAD' is used if not set" env:"GHCOMMIT_SHA"`
	Retries    int           `long:"retries" description:"Number of times to retry the commit if the branch head moved during the run (a concurrent push causes a STALE_DATA conflict). On conflict the current branch head is re-read and the same file changes are re-applied on top of it." env:"GHCOMMIT_RETRIES" default:"0"`
	RetryWait  time.Duration `long:"retry-wait" description:"Base backoff between retries; grows exponentially with jitter. Only used when --retries > 0." env:"GHCOMMIT_RETRY_WAIT" default:"2s"`
	Version    bool          `short:"v" long:"version" description:"Print version and exit"`
}

func main() {
	ctx := context.Background()

	_, err := flags.Parse(&opts)
	if err != nil {
		// no need to print error, flags.Parse() already does this
		os.Exit(1)
	}

	if opts.Version {
		log.Println(version)
		os.Exit(0)
	}

	if len(opts.Adds) == 0 && len(opts.Deletes) == 0 && !opts.Empty {
		log.Fatal("No files to commit. Use --empty flag to allow empty commits.")
	}

	ght := os.Getenv("GITHUB_TOKEN")
	if ght == "" {
		log.Fatal("GITHUB_TOKEN env var must be set")
	}

	ghes := os.Getenv("GITHUB_GRAPHQL_URL")

	tok := oauth2.StaticTokenSource(&oauth2.Token{AccessToken: ght})
	httpClient := oauth2.NewClient(ctx, tok)

	var client *githubv4.Client
	if ghes == githubGraphQLURL {
		client = githubv4.NewClient(httpClient)
	} else {
		client = githubv4.NewEnterpriseClient(ghes, httpClient)
	}

	// parse the commit message into headline and body
	headline, body := parseMessage(opts.Message)

	// if no head SHA is provided, try to get it by running git in the current directory
	expectedHeadOid := opts.HeadSHA
	if expectedHeadOid == "" {
		headSHA, err := getHeadSHA(ctx)
		if err != nil {
			log.Fatal(err)
		}
		expectedHeadOid = headSHA
	}

	// process added / modified files:
	additions := make([]githubv4.FileAddition, 0, len(opts.Adds))
	for _, f := range opts.Adds {
		enc, err := base64EncodeFile(f)
		if err != nil {
			log.Fatal(err)
		}
		additions = append(additions, githubv4.FileAddition{
			Path:     githubv4.String(f),
			Contents: githubv4.Base64String(enc),
		})
	}

	// process deleted files:
	deletions := make([]githubv4.FileDeletion, 0, len(opts.Deletes))
	for _, f := range opts.Deletes {
		deletions = append(deletions, githubv4.FileDeletion{
			Path: githubv4.String(f),
		})
	}

	// create the $input struct for the graphQL createCommitOnBranch mutation request:
	input := githubv4.CreateCommitOnBranchInput{
		Branch: githubv4.CommittableBranch{
			RepositoryNameWithOwner: githubv4.NewString(githubv4.String(opts.Repository)),
			BranchName:              githubv4.NewString(githubv4.String(opts.Branch)),
		},
		Message: githubv4.CommitMessage{
			Headline: githubv4.String(headline),
			Body:     githubv4.NewString(githubv4.String(body)),
		},
		FileChanges: &githubv4.FileChanges{
			Additions: &additions,
			Deletions: &deletions,
		},
		ExpectedHeadOid: githubv4.GitObjectID(expectedHeadOid),
	}

	url, err := commitWithRetry(ctx, client, opts.Repository, opts.Branch, input, opts.Retries, opts.RetryWait)
	if err != nil {
		log.Fatal(err)
	}
	log.Printf("Success. New commit: %s", url)
}

// commitWithRetry runs the createCommitOnBranch mutation, retrying on stale-head
// conflicts up to retries times. On conflict it re-reads the branch head and
// updates input.ExpectedHeadOid so the retry re-applies the same file changes on
// top of whatever concurrently moved the branch. Non-conflict errors are
// permanent. retries == 0 makes exactly one attempt.
func commitWithRetry(ctx context.Context, client *githubv4.Client, repository, branch string, input githubv4.CreateCommitOnBranchInput, retries int, wait time.Duration) (string, error) {
	var m struct {
		CreateCommitOnBranch struct {
			Commit struct {
				URL string
			}
		} `graphql:"createCommitOnBranch(input:$input)"`
	}

	commit := func() (string, error) {
		err := client.Mutate(ctx, &m, input, nil)
		if err == nil {
			return m.CreateCommitOnBranch.Commit.URL, nil
		}
		if !isStaleHeadConflict(err) {
			return "", backoff.Permanent(err)
		}
		newHead, refreshErr := currentHeadOid(ctx, client, repository, branch)
		if refreshErr != nil {
			return "", backoff.Permanent(fmt.Errorf("commit conflicted with a concurrent update, but refreshing the branch head failed: %v (original error: %w)", refreshErr, err))
		}
		log.Printf("commit conflicted with a concurrent update; refreshed head to %s, retrying", newHead)
		input.ExpectedHeadOid = newHead
		return "", err
	}

	b := backoff.NewExponentialBackOff()
	if wait > 0 {
		b.InitialInterval = wait
	}
	url, err := backoff.Retry(ctx, commit,
		backoff.WithBackOff(b),
		backoff.WithMaxTries(uint(retries)+1), // tries = 1 + retries
		backoff.WithMaxElapsedTime(0),         // bound by try count only, not wall-clock
	)
	if err != nil {
		// Unwrap so callers see the underlying GitHub error, not the RetryError.
		if re := backoff.AsRetryError(err); re != nil && re.LastErr != nil {
			return "", re.LastErr
		}
		return "", err
	}
	return url, nil
}

// isStaleHeadConflict matches on the message text because githubv4 surfaces the
// GraphQL STALE_DATA error as a plain error with no typed code.
func isStaleHeadConflict(err error) bool {
	if err == nil {
		return false
	}
	msg := strings.ToLower(err.Error())
	return strings.Contains(msg, "expected branch to point to") ||
		strings.Contains(msg, "pull and try again")
}

// currentHeadOid returns the commit oid at the tip of branch. It reuses the
// caller's client so the GITHUB_GRAPHQL_URL (GHES) endpoint is honored.
func currentHeadOid(ctx context.Context, client *githubv4.Client, repository, branch string) (githubv4.GitObjectID, error) {
	owner, name, ok := strings.Cut(repository, "/")
	if !ok || owner == "" || name == "" {
		return "", fmt.Errorf("invalid repository %q, expected \"owner/name\"", repository)
	}

	var q struct {
		Repository struct {
			Ref *struct {
				Target *struct {
					Oid githubv4.GitObjectID
				}
			} `graphql:"ref(qualifiedName: $qualifiedName)"`
		} `graphql:"repository(owner: $owner, name: $name)"`
	}
	vars := map[string]interface{}{
		"owner":         githubv4.String(owner),
		"name":          githubv4.String(name),
		"qualifiedName": githubv4.String("refs/heads/" + branch),
	}
	if err := client.Query(ctx, &q, vars); err != nil {
		return "", err
	}
	if q.Repository.Ref == nil || q.Repository.Ref.Target == nil {
		return "", fmt.Errorf("branch %q not found in %s", branch, repository)
	}
	return q.Repository.Ref.Target.Oid, nil
}

func base64EncodeFile(path string) (string, error) {
	in, err := os.Open(path)
	if err != nil {
		return "", err
	}
	defer in.Close() // nolint: errcheck

	buf := bytes.Buffer{}
	encoder := base64.NewEncoder(base64.StdEncoding, &buf)

	if _, err := io.Copy(encoder, in); err != nil {
		return "", err
	}
	if err := encoder.Close(); err != nil {
		return "", err
	}
	return buf.String(), nil
}

func parseMessage(msg string) (string, string) {
	parts := strings.SplitN(msg, "\n", 2)
	if len(parts) == 1 {
		return parts[0], ""
	}
	return parts[0], parts[1]
}

func getHeadSHA(ctx context.Context) (string, error) {
	out, err := exec.CommandContext(ctx, "git", "rev-parse", "HEAD").Output()
	if err != nil {
		return "", fmt.Errorf("error running 'git rev-parse HEAD': %s", err)
	}
	s := string(out)
	s = strings.TrimSuffix(s, "\n")
	return s, nil
}
