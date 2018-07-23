FROM registry.theplant-dev.com/sunfmin/openshift-go-app1dep
WORKDIR /go/src/github.com/theplant/openshift-go
COPY . .
COPY ./app1/static /app/
RUN set -x && \
    go get -d -v ./app1 && \
    CGO_ENABLED=0 GOOS=linux go build -o /app/app ./app1
