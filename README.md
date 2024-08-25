<img alt="Balkan Ruby logo" src="https://2018.balkanruby.com/static/assets/balkanruby-logo.svg">

Balkan Ruby is back to business!

## Development

Before running Balkan Ruby on your local macOS machine, you need the following software:

### Ready...

- Ruby 3.2.2
- SQLite3
- Foreman (or [hivemind](https://github.com/DarthSim/hivemind))

Install Ruby 3.3.3 with `rbenv`, `chruby` or `asdf`. Use [Homebrew](https://brew.sh) for everything else:

```
brew install sqlite3
```

With the dependencies installed, proceed to the next step.

### Steady...

Clone the repo.

```sh
git clone git@github.com:gsamokovarov/balkan.git
```

Setup project environment.

```sh
bin/setup
```

#### Stripe setup

> **Warning**
> Make sure you are using the test mode in Stripe.

1. Install [stripe cli](https://stripe.com/docs/stripe-cli)
2. Setup a [local listener for the webhooks](https://stripe.com/docs/development/dashboard/local-listener)
3. Make sure you have the following ENVs setup - e.g. [.env.erb](./.env.erb)

- STRIPE_SECRET_KEY
- STRIPE_WEBHOOK_SECRET

#### Sendgrid setup

The `SENDGRID_API_KEY` needs to be set with a random value e.g [.env.erb](./.env.erb).
In development & test emails are not sent.

#### Admin setup

The admin is accessed at `/admin` and requires basic HTTP authentication
controlled by 2 environment variables:

- `ADMIN_NAME`
- `ADMIN_PASSWORD`

Both of them default to `admin`.

### Go!

Start the application.

```sh
bin/dev
```
