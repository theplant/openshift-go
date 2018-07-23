FROM golang
WORKDIR /go/src/github.com/theplant/openshift-go/app1
COPY . .
RUN set -x && \
    go get -d -v .
