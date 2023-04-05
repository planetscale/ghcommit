deps:
	@go get

lint:
	@golangci-lint run -v --timeout=3m
	@if command -v goreleaser >/dev/null; then \
		goreleaser check; \
	else \
		echo "goreleaser not installed, skipping goreleaser linting"; \
	fi

test:
	@go test -coverprofile=cover.out -v ./...

cov:
	@go tool cover -html=cover.out

build-linux:
	@GOOS=linux GOOARCH=amd64 go build -trimpath -v ./

build:
	@go build -trimpath -v ./

goreleaser:
	@goreleaser $(GORELEASER_ARGS)

snapshot: GORELEASER_ARGS= --clean --snapshot
snapshot: goreleaser

autotag:
	@autotag -v

release: autotag
	@goreleaser $(GORELEASER_ARGS)

.PHONY: build build-linux cov test snapshot autotag release goreleaser