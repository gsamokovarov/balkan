# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Development Commands

### Setup and Installation
- `bin/setup` - Set up the development environment (installs dependencies, prepares database)
- `bundle install` - Install Ruby gems
- `bin/rails db:prepare` - Prepare the database (creates, loads schema, seeds)

### Development Server
- `bin/dev` - Start the development server using Foreman (includes Rails server and Stripe webhook listener)
- `bin/rails server` - Start Rails server only (port 3000)

### Testing
- `bundle exec rspec` - Run the full test suite
- `bundle exec rspec spec/path/to/specific_spec.rb` - Run a specific test file
- `bundle exec rspec spec/path/to/specific_spec.rb:line_number` - Run a specific test

### Code Quality
- `bundle exec rubocop` - Run RuboCop linter
- `bundle exec rubocop --auto-correct` - Auto-fix RuboCop violations

### Database
- `bin/rails db:migrate` - Run pending migrations
- `bin/rails db:rollback` - Rollback last migration
- `bin/rails db:seed` - Seed the database
- `bin/rails db:reset` - Drop, create, migrate, and seed database

## Architecture Overview

### Multi-Tenant Event System
The application is built around a multi-tenant architecture where each `Event` represents a conference. Events are selected based on:
- **Development**: `Settings.development_event` name
- **Production**: `request.host` domain matching

The `Current` class (ActiveSupport::CurrentAttributes) maintains thread-local state:
- `Current.event` - The active event for the request
- `Current.host` - Request host
- `Current.session` - Current user session

### Core Domain Models
- **Event**: Central entity representing a conference, owns all other resources
- **TicketType & Ticket**: Ticket sales and management
- **Order**: Purchase transactions with Stripe integration
- **Speaker & Talk**: Conference content management
- **Sponsor & Sponsorship**: Sponsorship packages and relationships
- **Subscriber**: Newsletter subscription management
- **User & Session**: Authentication system using custom session-based auth

### Admin System
- Custom admin interface at `/admin` with role-based access
- Admin scaffold generator: `bin/rails generate admin:scaffold ResourceName`
- Authentication via custom session system (not Devise)
- Default admin user: `admin@example.com` / `admin` (development only)

### View Partials
- Partials that accept local variables must declare them with the magic comment: `<%# locals: (pills:) %>`

### Key Architectural Patterns

#### Custom ActiveRecord Extensions
- `ApplicationRecord.page(number, per_page:)` - Simple pagination
- `time_as_boolean(attribute)` - Converts timestamps to boolean attributes
- Enhanced `accepts_nested_attributes_for` with automatic destroy handling

#### Request Context Management
- `ApplicationController` sets `Current.event` based on host/configuration
- All controllers inherit from `ApplicationController` for automatic event context

#### Payment Processing
- Stripe integration for ticket sales
- Webhook handling for payment confirmations
- Invoice generation with PDF support (Prawn gem)

## Technology Stack

### Backend
- **Rails 8** with SQLite3 (via Litestack for production features)
- **Authentication**: Custom session-based system (no Devise)
- **File Storage**: Active Storage with local/cloud storage
- **Background Jobs**: Litequeue (part of Litestack)
- **PDF Generation**: Prawn for invoices
- **Payments**: Stripe with webhook support

### Frontend
- **Styling**: Tailwind CSS
- **JavaScript**: Stimulus controllers with Turbo
- **Asset Pipeline**: Importmap for dependency management

### Development & Testing
- **Testing**: RSpec with custom xUnit dialect (rspec-xunit)
- **Browser Testing**: Capybara with Selenium WebDriver
- **Code Quality**: RuboCop
- **Process Management**: Foreman for development services

### Deployment
- **Infrastructure**: Custom server deployment via Hamal
- **Domain**: balkanruby.com
- **Environment**: Self-hosted with SQLite database

## Development Notes

### Stripe Setup (Optional)
For payment testing, configure:
1. Install Stripe CLI
2. Set up webhook listener: `stripe listen --forward-to localhost:3000/webhooks/stripe`
3. Set environment variables: `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`

### Database Notes
- Uses SQLite in all environments via Litestack
- Multiple database files: main data, queue system, cache
- Migrations include event-specific and multi-tenant considerations

### Custom Generators
- Admin scaffold generator creates full CRUD admin interface
- Templates in `lib/generators/admin/templates/`
- Auto-generates controller, views, and routes

### Testing Philosophy
- Uses RSpec with xUnit-style syntax via rspec-xunit gem
- Factory Bot for test data generation
- Capybara for integration testing with screenshot support
- **Use RSpec-XUnit dialect**: `RSpec.case` instead of `RSpec.describe`
- **Use `test` blocks**: Instead of `it` blocks for test definitions
- **Use assertions**: `assert_eq`, `assert_have_http_status` instead of expectations (`expect().to`)
- **Flat structure**: No nested `describe` or `context` blocks - keep tests at top level

### Assertion Patterns
```ruby
# Preferred: Complete response assertion
assert_eq response.parsed_body, {
  "users" => [
    {
      "id" => user.id,
      "name" => user.name,
      # ... all expected fields
    }
  ]
}

# Avoid: Partial assertions
assert_eq response.parsed_body["users"][0]["id"], user.id
```

