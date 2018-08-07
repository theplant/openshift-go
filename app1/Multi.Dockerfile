FROM registry.theplant-dev.com/sunfmin/openshift-go-app1dep as builder
WORKDIR /go/src/github.com/theplant/openshift-go
COPY . .
COPY ./app1/Dockerfile /
COPY ./app1/static /app/static
RUN set -x && \
    go get -d -v ./app1 && \
    CGO_ENABLED=0 GOOS=linux go build -o /app/entry ./app1

FROM alpine
COPY --from=builder /app/entry /app/entry
CMD ["/app/entry"]
