package main

import (
	"bytes"
	"context"
	"encoding/base64"
	"io"
	"log"
	"os"
	"os/exec"
	"strings"

	"github.com/jessevdk/go-flags"
	"github.com/shurcooL/githubv4"
	"golang.org/x/oauth2"
)

var opts struct {
	Adds       []string `short:"a" long:"add" description:"Added or modified file to commit. Use multiple times for multiple files." env:"GHCOMMIT_ADD"`
	Deletes    []string `short:"d" long:"delete" description:"Deleted file to commit. Use multiple times for multiple files." env:"GHCOMMIT_DELETE"`
	Message    string   `short:"m" long:"message" description:"Commit message" env:"GHCOMMIT_MESSAGE" required:"true"`
	Repository string   `short:"r" long:"repository" description:"Owner/Repository to commit to." env:"GHCOMMIT_REPOSITORY" required:"true"`
	Branch     string   `short:"b" long:"branch" description:"Branch to commit to." env:"GHCOMMIT_BRANCH" required:"true"`
	HeadSHA    string   `short:"s" long:"sha" description:"Commit SHA of the HEAD branch to apply to. Acts as a safety check to ensure the right branch is modified. The output of 'git rev-parse {branch}' is used if not set" env:"GHCOMMIT_SHA"`
}

func main() {
	ctx := context.Background()

	_, err := flags.Parse(&opts)
	if err != nil {
		// no need to print error, flags.Parse() already does this
		os.Exit(1)
	}

	if len(opts.Adds) == 0 && len(opts.Deletes) == 0 {
		log.Fatal("No files to commit")
	}

	ght := os.Getenv("GITHUB_TOKEN")
	if ght == "" {
		log.Fatal("GITHUB_TOKEN env var must be set")
	}

	tok := oauth2.StaticTokenSource(&oauth2.Token{AccessToken: ght})
	httpClient := oauth2.NewClient(ctx, tok)
	client := githubv4.NewClient(httpClient)

	var m struct {
		CreateCommitOnBranch struct {
			Commit struct {
				URL string
			}
		} `graphql:"createCommitOnBranch(input:$input)"`
	}

	// parse the commit message into headline and body
	headline, body := parseMessage(opts.Message)

	// if no head SHA is provided, try to get it by running git in the current directory
	expectedHeadOid := opts.HeadSHA
	if expectedHeadOid == "" {
		headSHA, err := getHeadSHA(ctx, opts.Branch)
		if err != nil {
			log.Fatal(err)
		}
		expectedHeadOid = headSHA
	}

	// create the $input struct for the graphQL createCommitOnBranch mutation:
	input := githubv4.CreateCommitOnBranchInput{
		Branch: githubv4.CommittableBranch{
			RepositoryNameWithOwner: githubv4.NewString(githubv4.String(opts.Repository)),
			BranchName:              githubv4.NewString(githubv4.String(opts.Branch)),
		},
		Message: githubv4.CommitMessage{
			Headline: githubv4.String(headline),
			Body:     githubv4.NewString(githubv4.String(body)),
		},
		ExpectedHeadOid: githubv4.GitObjectID(expectedHeadOid),
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

	input.FileChanges = &githubv4.FileChanges{
		Additions: &additions,
		Deletions: &deletions,
	}

	if err := client.Mutate(ctx, &m, input, nil); err != nil {
		log.Fatal(err)
	}
	log.Printf("Success. New commit: %s", m.CreateCommitOnBranch.Commit.URL)
}

func base64EncodeFile(path string) (string, error) {
	in, err := os.Open(path)
	if err != nil {
		return "", err
	}
	defer in.Close()

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

func getHeadSHA(ctx context.Context, ref string) (string, error) {
	out, err := exec.CommandContext(ctx, "git", "rev-parse", ref).Output()
	if err != nil {
		return "", err
	}
	s := string(out)
	s = strings.TrimSuffix(s, "\n")
	return s, nil
}
