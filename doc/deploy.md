Documentation for the `bin/deploy` script: how it works, how to configure it, and how to provision
new servers.

**PLACEHOLDERS**: Some commands and configuration snippets described in this configuration are
app-specific, i.e. their exact contents will vary from app to app. In order to make this
documentation generic, the `#{app_name}` and `#{app_domain}` placeholders are used in such places.
Replace the placeholders with the respective values in `config/deploy.yml` before executing the
commands / copying the configuration.

# Overview

`bin/deploy` implements a simple deploy process for a self-hosted app on a server that you
administer. It:
1. Connects to the server via SSH. (All subsequent stages happen on the server)
2. Fetches the code that will be deployed from GitHub.
3. Builds a Docker image containing the app's code.
4. Uses that image to run the app in a container.
5. Configures nginx to expose the app container to the Internet.

## Prerequisites

To deploy the app to a server, you will need:
* A bare-bones Ubuntu 22.04 server. We're currently using Hetzner for virtual servers.
* SSH access as `root` to that server.

# Provision

When you want to deploy the app on a new server, prepare it for service first by following the
steps in this section.

## Server settings (in the cloud provider)

- TODO: Restrict access to ports HTTPS and SSH

## System settings (on the server)

### Update packages

Install latest updates. You'd likely want to do this periodically.

```
apt update
apt upgrade
```

Note: If provisioning an arm64 Hetzner server, make sure the mirrors in `/etc/apt/sources.list` are
using `http://mirror.hetzner.com/ubuntu-ports/packages/` URLs instead of
`http://mirror.hetzner.com/ubuntu/packages/` (see
https://status.hetzner.com/incident/43b5f083-cb30-4c01-b904-b611206eb172).

### Tighten SSH config

In `/etc/ssh/sshd_config`:
- Set `PasswordAuthentication` to `no`
- Comment out the `Subsystem sftp` line

### Restart for changes to take effect

```
reboot
```

## Docker

Follow the [official docs](https://docs.docker.com/engine/install/ubuntu/).
The following should just work:

```
curl -fsSL https://get.docker.com | sh
```

## nginx

### Install

Follow the [official docs](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/#installing-prebuilt-ubuntu-packages).
In short:

```
apt install curl gnupg2 ca-certificates lsb-release ubuntu-keyring
curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
# Verify keyring (see official docs for that)
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" | tee /etc/apt/sources.list.d/nginx.list
echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | tee /etc/apt/preferences.d/99nginx
apt update
apt install nginx
systemctl start nginx
```

### Configure (part 1, before we have an SSL certificate)

We need this first incomplete part of the nginx configuration so that we can issue an SSL certificate.

Create the directory that will serve static content for the SSL verification process:

```
mkdir /usr/share/nginx/cert_validations
```

Replace the contents of `/etc/nginx/nginx.conf` with the following:

```
user nginx;
worker_processes auto;

error_log /var/log/nginx/error.log notice;
pid       /var/run/nginx.pid;

events {
  worker_connections 1024;
}

http {
  include      /etc/nginx/mime.types;
  default_type application/octet-stream;

  log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                  '$status $body_bytes_sent "$http_referer" '
                  '"$http_user_agent" "$http_x_forwarded_for"';
  access_log /var/log/nginx/access.log main;

  sendfile on;
  keepalive_timeout 65;

  ssl_session_cache   shared:SSL:10m;
  ssl_session_timeout 10m;

  server {
    listen 80;

    location /.well-known/acme-challenge/ {
      root /usr/share/nginx/cert_validations;
    }
  }
}
```

Apply the changes:

```
nginx -s reload
```

### Issue SSL certificate

Install certbot:

```
apt install snapd
snap install core
snap refresh core
snap install --classic certbot
```

Issue a certificate:

```
certbot certonly -m genadi@hey.com --webroot -w /usr/share/nginx/cert_validations -d #{app_domain}
```

Let's Encrypt certificates are only valid for 90 days and need to be renewed regularly. There's no
need to manually create a cron, though, the certbot snap installation has already taken care of
this by registering a `snap.certbot.renew.timer` systemd timer (check `systemctl list-timers`).

Test that the renewal process is properly set up:

```
certbot renew --dry-run
```

You should see a success message for the certificate we just issued.

### Configure (part 2, after we have an SSL certificate)

Create `/etc/nginx/#{app_name}.conf.template` with the following contents:

```
server {
  listen      443 ssl;
  server_name #{app_domain};

  ssl_certificate     /etc/letsencrypt/live/#{app_domain}/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/#{app_domain}/privkey.pem;

  location / {
    proxy_pass http://localhost:$ACTIVE_RAILS_PORT;
  }
}
```

Create a temporary dummy `#{app_name}.conf` file. This will get overwritten by the actual deploy
process, but we need it for now to bootstrap nginx with a valid config:

```
ACTIVE_RAILS_PORT=80 envsubst < /etc/nginx/#{app_name}.conf.template > /etc/nginx/#{app_name}.conf
```

Add the following include line at the end of the `http` block in `/etc/nginx/nginx.conf`:

```
http {
  ...
  include /etc/nginx/#{app_name}.conf;
}
```

Apply the changes:

```
nginx -s reload
```

## Deploy user and directories

- Create app user (with the same UID as the user created in the Dockerfile)

  ```
  useradd rails --uid 1001 --create-home --shell /bin/bash
  ```

- Create directories

  ```
  mkdir -p /var/lib/#{app_name}/db
  mkdir -p /var/lib/#{app_name}/src
  chown rails:rails /var/lib/#{app_name}/db
  ```

## Secrets

Store `RAILS_MASTER_KEY` on the server:

```
echo RAILS_MASTER_KEY=<actual_secret> > /var/lib/#{app_name}/env_file
```

## Database

If this is an existing app, restore its database to `/var/lib/#{app_name}/db`. Make sure its owner
user and group are `rails:rails`.

If this is a new app, create its database by running `bin/rails db:create` in out of its images. You
will likely have to do this at a later point, when you do have such an image. Examine `bin/deploy`
to determine what arguments to `docker run` are needed, e.g. to set ENV variables and mount host
directories. The final commands you're looking for will look something like this:

```
docker run --rm <args inferred from bin/deploy> --entrypoint '/rails/bin/rails' <app_image> -- db:create
docker run --rm <args inferred from bin/deploy> --entrypoint '/rails/bin/rails' <app_image> -- db:schema:load
```

## GitHub

Create and add a deploy key to grant the server read-only access to this repository. Follow the
[official docs](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/managing-deploy-keys#deploy-keys).
In short:

1. Create a new SSH key for the root user on the server

   ```
   ssh-keygen -t ed25519 -C "Hetzner_<serverIP>" -f ~/.ssh/github_deploy
   ```

   Leave the passphrase empty.

2. Add the key to GitHub

   Open repository in GitHub, in "Settings" -> "Deploy keys" press "Add deploy key". Enter a title
   (e.g. the `Hetzner_<serverIP>` comment), the public key you just created (i.e. the contents of
   `.ssh/github_deploy.pub`), and press "Add key".

3. Configure SSH on the server to use this key when connecting to GitHub

   Create `~/.ssh/config` with the following contents:

   ```
   Host github.com
       IdentityFile ~/.ssh/github_deploy
   ```

# Configuration

The deploy script expects certain configuration in `config/deploy.yml`:

- `github_repo`: The repo where the app's source is located, in the form `<username>/<repo_name>`.
- `app_name`: Used as part of directory and Docker image names, so must be a valid identifier: only
  letters, numbers, and underscores.
- `app_domain`: The hostname that this app will be accessible at.
- `server`: The IP address of a provisioned server.
- `local_ports`: An array of at least two ports that will be used by the run the app locally on the
  server. These ports will not be exposed to the Internet. If you're using the server to host
  multiple apps using this script, make sure that all apps are configured with unique ports so that
  they do not conflict with each other.

# Deploy

Just pass the commit you want deployed to `bin/deploy`:

```
bin/deploy b04c0b567dc0e94f2c87cbb06f778008e275804b
```

Note: The commit must have been pushed to the Github repo. The deploy script does not deploy local
commits.
