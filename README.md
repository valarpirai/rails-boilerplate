# README

#### [Tech Reference](https://www.freecodecamp.org/news/have-an-idea-want-to-build-a-product-from-scratch-heres-a-checklist-of-things-you-should-go-through-in-your-backend-software-architecture/)

This README would normally document whatever steps are necessary to get the
application up and running.

* Setup
    - Clone this repo

    - [Install RVM (Ruby Version Manager)](https://rvm.io/rvm/install)

        `rvm install ruby-2.6.6`

        `cd rails-boilerplate/`

        `bundle install`

    - Install NodeJS - JS Environment
        `brew install node`

    - [Install Redis](https://gist.github.com/tomysmile/1b8a321e7c58499ef9f9441b2faa0aa8)
    - [Install MySQL Server](https://gist.github.com/operatino/392614486ce4421063b9dece4dfe6c21)

* System dependencies

* Configuration

* Database creation
    * `bundle exec rake db:create`
* Database initialization
    * `bundle exec rake db:bootstrap`

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)
    * `rails s` - Start server

* Deployment instructions

* ...


### Websocket Testing
Websocket Basic Auth
`wscat -c ws://localhost:3001/cable -o http://localhost.myapp-dev.com:3001/ --auth rbx-ae6b7d4949a226e235fa:x`

Subscribe to Channel
`{"command":"subscribe","identifier":"{\"channel\":\"ApplicationCable::FeatureFlagsChannel\"}"}`

### Production

`RAILS_ENV=production rake secret`
`export SECRET_KEY_BASE=generated_key`

`RAILS_ENV=production rake assets:precompile`
`export RAILS_SERVE_STATIC_FILES=true`
`RAILS_ENV=production rails s -u puma`
