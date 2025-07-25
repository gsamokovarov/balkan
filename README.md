# Balkan Ruby

<img alt="Balkan Ruby logo" src="https://2018.balkanruby.com/static/assets/balkanruby-logo.svg">

This is the codebase powering [balkanruby.com](https://balkanruby.com) and
other [Neuvents](https://neuvents.com/) run events.

## About

This Rails application is designed specifically to meet the needs of running
Balkan Ruby – from ticket sales and speaker management to sponsor coordination
and conference day logistics. The code prioritizes pragmatic solutions over
architectural complexity.

## Development

### Prerequisites

Before running Balkan Ruby on your local machine, you need:

- **Ruby 3.4.4** (install with `rbenv`, `chruby`, or `asdf`)
- **SQLite3** (install with `brew install sqlite3`)
- **Foreman** or [Hivemind](https://github.com/DarthSim/hivemind) for process management

### Installation

1. **Clone the repository**
   ```sh
   git clone git@github.com:gsamokovarov/balkan.git
   cd balkan
   ```

1. **Setup the project**
   ```sh
   bin/setup
   ```
   This will install dependencies, setup the database, and prepare the development environment.

1. **Configure Stripe (Required for payments)**

   ⚠️ **Important**: Use Stripe test mode only in development

   - Install [Stripe CLI](https://stripe.com/docs/stripe-cli)
   - Setup [local webhook listener](https://stripe.com/docs/development/dashboard/local-listener)
   - Configure environment variables (see `.env.erb` example):
     - `STRIPE_SECRET_KEY`
     - `STRIPE_WEBHOOK_SECRET`

1. **Admin Access**

   Access the admin interface at `/admin` using:
   - **Email**: `admin@example.com`
   - **Password**: `admin`

### Running the Application

Start the development server and webhook listener:

```sh
bin/dev
```

This runs both the Rails server and Stripe webhook listener using Foreman.

## Testing

Run the test suite:

```sh
bundle exec rspec
```

The project uses RSpec but with a twist – I enjoy minitest because of its
simplicity, however, I love RSpec's runner and tooling. I created
[rspec-xunit](https://github.com/gsamokovarov/rspec-xunit) so I use can RSpec with a xUnit
testing dialect.

## Deployment

This application is deployed to a custom server maintained by me and @nenoganchev using
[Hamal](https://github.com/gsamokovarov/hamal), a simple deployment tool we
created for its deployment. The deployment configuration is in `config/deploy.yml`.

To deploy (if you have access):

```sh
bin/hamal deploy
```

## Philosophy

- **Solve real problems**: Every feature exists to solve a real need for running Balkan Ruby
- **Prefer simplicity**: Choose simple solutions over complex abstractions
- **Embrace Rails conventions**: Leverage Rails' strengths rather than fighting them
- **Have fun**: I get to do a hack or two to numb the pain of running a conference

## Contributing

**Important**: This code is and always will be specific to Balkan Ruby and the
events I run. If you find this code useful for your own conference or project,
you're free to fork it and adapt it to your needs.

## License

This project is open source under the MIT License. See the LICENSE file for details.
