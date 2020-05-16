# Furnitrackr

[![Codeship Status for gdiasdasilva/furnitrackr](https://app.codeship.com/projects/4f9aa7c0-3326-0138-cd31-265415f14eb5/status?branch=master)](https://app.codeship.com/projects/385596)

Furnitrackr is a price tracker for your products, built with Ruby on Rails.

In this app, any user may add an URL for an IKEA product, set a threshold price and be notified when the product's price falls below that predefined value.

## Versions

* Ruby version: 2.6.6
* PostgreSQL version: 12.0
* Ruby on Rails version: 6.0.3

## Running the project

### Local installation

```
$ bundle install
$ rails db:create db:migrate db:seed
$ rails s
```

### Docker

You'll need Docker and docker-compose installed in your machine.

```
$ docker build -t furnitrackr .
$ docker-compose up
```

At this point, you should be able to visit the application at `localhost:3000`.

## Testing

- Running the entire test suite: `rspec spec`

## Deployment instructions

Deploys are automatic and triggered when builds in the `master` branch pass the test suite.
