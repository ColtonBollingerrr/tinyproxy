# Tinyproxy on Cloud Run
FROM alpine:3.20

# Install tinyproxy
RUN apk add --no-cache tinyproxy

# Create a minimal config
RUN mkdir -p /etc/tinyproxy && \
    echo "User nobody" > /etc/tinyproxy/tinyproxy.conf && \
    echo "Group nogroup" >> /etc/tinyproxy/tinyproxy.conf && \
    echo "Port 8888" >> /etc/tinyproxy/tinyproxy.conf && \
    echo "Listen 0.0.0.0" >> /etc/tinyproxy/tinyproxy.conf && \
    echo "Timeout 600" >> /etc/tinyproxy/tinyproxy.conf && \
    echo "MaxClients 100" >> /etc/tinyproxy/tinyproxy.conf && \
    echo "LogLevel Info" >> /etc/tinyproxy/tinyproxy.conf && \
    echo "PidFile \"/tmp/tinyproxy.pid\"" >> /etc/tinyproxy/tinyproxy.conf && \
    echo "Allow 0.0.0.0/0" >> /etc/tinyproxy/tinyproxy.conf && \
    echo "ConnectPort 443" >> /etc/tinyproxy/tinyproxy.conf && \
    echo "ConnectPort 80" >> /etc/tinyproxy/tinyproxy.conf

# Expose Cloud Run $PORT
ENV PORT=8080

# Run tinyproxy on Cloud Run’s dynamic port
CMD ["/bin/sh", "-c", "sed -i \"s/^Port .*/Port ${PORT}/\" /etc/tinyproxy/tinyproxy.conf && tinyproxy -d -c /etc/tinyproxy/tinyproxy.conf"]
