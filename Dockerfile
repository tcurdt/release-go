FROM golang:1.17-alpine AS builder
RUN apk update && apk upgrade \
 && apk add --no-cache ca-certificates upx

# FROM alpine:edge AS builder
# RUN apk update && apk upgrade \
#  && apk add --no-cache ca-certificates \
#  && apk add --no-cache --update go=1.15.2-r0 upx

WORKDIR /app
ADD . /app
RUN echo "nobody:x:65534:65534:Nobody:/:" > /app/passwd
RUN CGO_ENABLED=0 go mod download \
 && CGO_ENABLED=0 go build -ldflags="-s -w" && find . && upx release-go

FROM scratch
WORKDIR /app
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /app/passwd /etc/passwd
COPY --from=builder /app/release-go /bin/release-go
USER nobody
CMD ["/bin/release-go"]
