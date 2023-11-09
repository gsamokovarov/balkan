![Balkan Ruby][logo]

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

After installing the dependencies, setup admin usage credentials by exporting:

```
export ADMIN_NAME=admin
export ADMIN_PASSWORD=admin
```

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

[logo]: https://raw.githubusercontent.com/gsamokovarov/balkan/main/app/assets/images/logo-black.svg?token=GHSAT0AAAAAACJMMNZ5YAAQTIPUE2K3B2AWZKNCUJQ
