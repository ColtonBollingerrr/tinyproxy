# Tinyproxy for Cloud Run
FROM alpine:3.20

RUN apk add --no-cache tinyproxy

# default config
RUN mkdir -p /etc/tinyproxy && cat > /etc/tinyproxy/tinyproxy.conf <<'EOF'
User nobody
Group nogroup
Port 8080
Listen 0.0.0.0
Timeout 600
MaxClients 100
LogLevel Info
PidFile "/tmp/tinyproxy.pid"
# Open proxy — lock this down if you can
Allow 0.0.0.0/0
ConnectPort 80
ConnectPort 443
EOF

ENV PORT=8080

# on start, rewrite Port to $PORT and run in foreground (-d)
CMD sh -c "sed -i \"s/^Port .*/Port ${PORT}/\" /etc/tinyproxy/tinyproxy.conf && exec tinyproxy -d -c /etc/tinyproxy/tinyproxy.conf"
