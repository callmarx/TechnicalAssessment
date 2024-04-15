FROM golang:1.21-alpine as build

ENV GOPATH /go
ENV CGO_ENABLED 0


RUN apk add -U --no-cache ca-certificates
RUN apk add -U curl
RUN apk add -U grep
RUN curl -s -q https://raw.githubusercontent.com/minio/mc/master/LICENSE -o /go/LICENSE
RUN curl -s -q https://raw.githubusercontent.com/minio/mc/master/CREDITS -o /go/CREDITS
RUN go install -v -ldflags "$(go run buildscripts/gen-ldflags.go)" "github.com/minio/mc@latest"

FROM scratch

COPY --from=build /go/bin/mc  /usr/bin/mc
COPY --from=build /go/CREDITS /licenses/CREDITS
COPY --from=build /go/LICENSE /licenses/LICENSE
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY entrypoints/setup_minio-entrypoint.sh /

ENTRYPOINT ["setup_minio-entrypoint.sh"]
