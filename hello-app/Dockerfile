FROM --platform=$BUILDPLATFORM golang:1.21 as builder

ARG TARGETOS TARGETARCH
ENV GOOS $TARGETOS
ENV GOARCH $TARGETARCH

WORKDIR /app
RUN go mod init hello-app
COPY * ./
RUN go build -o /hello-app

FROM --platform=$BUILDPLATFORM gcr.io/distroless/base-debian12
WORKDIR /
COPY --from=builder /hello-app /hello-app
COPY --from=builder /app .
ENV PORT 8080
USER nonroot:nonroot
CMD ["/hello-app"]