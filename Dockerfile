FROM golang:alpine

ARG REPO=https://github.com/aptly-dev/aptly.git
ARG BRANCH=master

WORKDIR /build

RUN apk add --no-cache git && \
    git clone "$REPO" --branch "$BRANCH" . && \
	go build \
        -v \
        -ldflags "-X main.Version=$(git describe --tags | sed 's@^v@@' | sed 's@-@+@g')" \
        -o /aptly && \
    /aptly version

FROM spritsail/alpine:3.12

COPY --from=0 /aptly /bin/

CMD ["/bin/aptly"]
