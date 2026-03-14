# CloudBeaver on EC2 — Setup Guide

How we deployed CloudBeaver (web-based SQL editor) on AWS for Quiz 02, so students could run SQL from locked-down classroom computers with no local software installed.

## Architecture

```
Student browser
    → https://dbeaver.isba.co
    → Caddy (reverse proxy, auto HTTPS via Let's Encrypt)
    → CloudBeaver Docker container (localhost:8978)
    → MySQL RDS (basket_craft database)
```

## EC2 Instance

| Setting | Value |
|---------|-------|
| AMI | Amazon Linux 2023 (`ami-0c421724a94bba6d6`) |
| Instance type | `t3.small` |
| Key pair | `lesson_exercises` |
| Security group | `cloudbeaver-quiz` (`sg-08d3f0ec116ffe062`) |
| Public IP | `98.81.216.150` |
| Instance ID | `i-05682a6deb3f8315b` |

### Security group rules (inbound)

| Port | Protocol | Source | Purpose |
|------|----------|--------|---------|
| 22 | TCP | 0.0.0.0/0 | SSH |
| 80 | TCP | 0.0.0.0/0 | HTTP (Caddy redirect to HTTPS) |
| 443 | TCP | 0.0.0.0/0 | HTTPS (Caddy) |

## SSH access

We used EC2 Instance Connect instead of a .pem key file:

```bash
# Push your local SSH key to the instance (valid for 60 seconds)
aws ec2-instance-connect send-ssh-public-key \
    --instance-id i-05682a6deb3f8315b \
    --instance-os-user ec2-user \
    --ssh-public-key file://~/.ssh/id_ed25519.pub

# Then SSH immediately
ssh ec2-user@98.81.216.150
```

## Step 1: Install Docker and run CloudBeaver

```bash
sudo dnf install -y docker
sudo systemctl enable --now docker
sudo usermod -aG docker ec2-user

# Bind to localhost only — Caddy handles public traffic
docker run -d \
    --name cloudbeaver \
    --restart unless-stopped \
    -p 127.0.0.1:8978:8978 \
    -v /opt/cloudbeaver/workspace:/opt/cloudbeaver/workspace \
    dbeaver/cloudbeaver:latest
```

Binding to `127.0.0.1:8978` (not `0.0.0.0`) is important — it prevents direct public access to port 8978 and lets Caddy handle HTTPS termination.

## Step 2: Install Caddy (reverse proxy with auto HTTPS)

Caddy automatically provisions and renews Let's Encrypt TLS certificates. No certbot, no cron jobs.

```bash
# Download Caddy binary directly (COPR repo doesn't work on Amazon Linux 2023)
curl -o /tmp/caddy "https://caddyserver.com/api/download?os=linux&arch=amd64"
sudo mv /tmp/caddy /usr/bin/caddy
sudo chmod +x /usr/bin/caddy
```

### Caddyfile

```bash
sudo mkdir -p /etc/caddy
sudo tee /etc/caddy/Caddyfile > /dev/null <<'EOF'
dbeaver.isba.co {
    reverse_proxy localhost:8978
}
EOF
```

### Systemd service

```bash
sudo tee /etc/systemd/system/caddy.service > /dev/null <<'EOF'
[Unit]
Description=Caddy web server
After=network.target

[Service]
ExecStart=/usr/bin/caddy run --config /etc/caddy/Caddyfile
ExecReload=/usr/bin/caddy reload --config /etc/caddy/Caddyfile
Restart=on-failure
AmbientCapabilities=CAP_NET_BIND_SERVICE

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now caddy
```

## Step 3: DNS

Create an A record pointing to the EC2 public IP:

```
dbeaver.isba.co → 98.81.216.150
```

Caddy won't provision the TLS certificate until DNS resolves correctly.

## Step 4: Configure CloudBeaver connection

1. Open `https://dbeaver.isba.co` and log in as admin (first-time setup wizard)
2. Create a MySQL connection to the RDS instance (connection details provided separately, not stored here)
3. Check "Save credentials" so students don't need the password
4. Go to the connection's Access tab and grant access to the "User" team — this allows anonymous users to see and use the connection

## Teardown

When the quiz is over:

```bash
# Terminate the EC2 instance
aws ec2 terminate-instances --instance-ids i-05682a6deb3f8315b

# Delete the security group (after instance terminates)
aws ec2 delete-security-group --group-id sg-08d3f0ec116ffe062

# Remove the DNS A record for dbeaver.isba.co (do this in your DNS provider)
```

## Lessons learned

- **Port conflicts**: If Docker binds to `0.0.0.0:80`, Caddy can't start. Always bind Docker to `127.0.0.1:<port>`.
- **Anonymous access**: Creating a connection in CloudBeaver doesn't make it visible to anonymous users by default. You have to explicitly grant access to the "User" team on the connection's Access tab.
- **CloudBeaver doesn't auto-save**: Students need to download their .sql file regularly. We added a warning to the quiz template about this.
- **COPR repo 404**: The Fedora COPR repo URL for Caddy returns 404 on Amazon Linux 2023. Download the binary directly from caddyserver.com instead.
- **No .pem key needed**: EC2 Instance Connect lets you push a temporary SSH key without needing the original .pem file on your machine.
