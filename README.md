<img alt="Balkan Ruby logo" src="https://2018.balkanruby.com/static/assets/balkanruby-logo.svg">

Balkan Ruby is back to business!

## Development

Before running Balkan Ruby on your local macOS machine, you need the following software:

### Ready...

- Ruby 3.2.2
- PostgreSQL v12+
- Foreman or Hivemind

Install Ruby 3.2.2 with `rbenv`, `chruby` or `asdf`. Use [Homebrew](https://brew.sh) for everything else:

```
brew install postgresql hivemind
```

With the dependencies installed, setup the project itself with `bin/setup`.

### Steady...

(Import maps are great, you have nothing else to configure...)

### Go!

Having the required software and **env**ironment setup run the development server with `hivemind`.

## Development

### Setup

Clone the repo.

```sh
git clone git@github.com:gsamokovarov/balkan.git
```

Setup project environment.

```sh
bin/setup
```

Start the application.

```sh
bin/dev
```
