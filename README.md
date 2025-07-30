<img alt="Balkan Ruby logo" src="https://2018.balkanruby.com/static/assets/balkanruby-logo.svg">

[Balkan Ruby 2026](https://balkanruby.com) is about the hot takes, the spicy
memes, and (humbly) the best Ruby conference in the world.

Was this README AI-generated? Can the kids these days still write (or code)?
Are SPAs still worth it, or should we let the servers serve? Is cloud computing
still on, or should you own your servers? Typed Ruby, when?

Give us all your hot takes for a spicy [Balkan Ruby 2026](https://balkanruby.com)
in Sofia, Bulgaria.

## About

This is the codebase for the [Balkan Ruby](https://balkanruby) conference
website and its CMS, or conference-management-system. The codebase is
pragmatic and modern. Most of the Balkan Ruby conference needs are covered by a
custom-built admin management solution, but some features are still hard-coded.
Welcome to the Balkans, where construction (and software development) is done
for the sake of construction and is never finished.

## Development

- Ruby 3.4.4
- SQLite3
- Foreman (or [hivemind](https://github.com/DarthSim/hivemind))

Install Ruby 3.4.4 with `rbenv`, `chruby`, or `asdf`. Use
[Homebrew](https://brew.sh), Portage, or pacman (if you are a noob), for
everything else:

```
brew install sqlite3 libvips
```

With the dependencies installed, proceed to the next step and...

### Pour the rakia

Clone the repo:

```sh
git clone git@github.com:gsamokovarov/balkan.git
```

Set up the project development environment:

```sh
bin/setup
```

#### Prepare the salad (optional)

Optionally, you can set up the project to accept payments via Stripe in
development. Without it, payments in development will not work but running the
application through `bin/dev` will still work. Sorry for the spoilers.

> **Warning**
> Make sure you are using the test mode in Stripe for local development.

1. Install [stripe cli](https://stripe.com/docs/stripe-cli)
2. Set up a [local listener for the webhooks](https://stripe.com/docs/development/dashboard/local-listener)
3. Make sure you have the following ENVs set up - e.g,. [.env.erb](./.env.erb)

- STRIPE_SECRET_KEY
- STRIPE_WEBHOOK_SECRET

#### Resolve the geopolitical issues (required)

The admin is accessed at `/admin`. The `admin@example.com` user is seeded with
the password `admin` that you can use for development.

### Enjoy it (responsibly)

Start the application.

```sh
bin/dev
```

## Testing

Run the test suite:

```sh
bundle exec rspec
```

The project uses RSpec, but with a twist – I enjoy minitest because of its
simplicity, however, I love RSpec's runner and tooling. I created [rspec-xunit](https://github.com/gsamokovarov/rspec-xunit)
so I can use RSpec with an xUnit testing dialect.

## Deployment

This application is deployed to a custom server maintained by me and [Neno Ganchev](https://github.com/nenoganchev)
using [Hamal](https://github.com/gsamokovarov/hamal), a simple deployment tool we
created. The deployment configuration lives in `config/deploy.yml`.

To deploy (if you have access):

```sh
bin/hamal deploy
```

## Contributing

This code is and always will be specific to Balkan Ruby and the events I run.
If you find this code useful for your conference or project, you're free to
fork it and adapt it to your needs.

## License

This project is open source under the MIT License. Do whatever you want with
it, just don't sue me (or request features).
