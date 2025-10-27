FROM golang:latest AS builder

WORKDIR /app

COPY ./ ./
RUN make build

FROM registry.access.redhat.com/ubi9/ubi-minimal:latest
WORKDIR /app
COPY --from=builder /app/kubernetes-mcp-server /app/kubernetes-mcp-server
#USER 65532:65532
RUN chmod +x /app/kubernetes-mcp-server && \
    chown -R 1001:0 /app && \
    chmod -R g=u /app
ENTRYPOINT ["/app/kubernetes-mcp-server", "--port", "8080"]

EXPOSE 8080
