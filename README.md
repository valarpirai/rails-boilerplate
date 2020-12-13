# README

## Reference
https://www.freecodecamp.org/news/have-an-idea-want-to-build-a-product-from-scratch-heres-a-checklist-of-things-you-should-go-through-in-your-backend-software-architecture/

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

rvm --create --ruby-version ruby-2.6.3@boilerplate

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


Websocket Basic Auth
`wscat -c ws://localhost:3001/cable -o http://localhost.myapp-dev.com:3001/ --auth rbx-ae6b7d4949a226e235fa:x`

Subscribe to Channel
`{"command":"subscribe","identifier":"{\"channel\":\"ApplicationCable::FeatureFlagsChannel\"}"}`
