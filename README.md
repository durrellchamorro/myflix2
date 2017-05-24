# MyFLIX
[![CircleCI](https://circleci.com/gh/durrellchamorro/myflix2/tree/master.svg?style=svg)](https://circleci.com/gh/durrellchamorro/myflix2/tree/master)
# Features

#### Registration, Authentication, and Payments
* Hand-rolled authentication, using bcrypt for password encryption
* Uses Stripe API for: subscribing customers to the monthly plan, storing and charging credit cards
* Disables user access when payments fail
* Users can view their payment history
* Sends a welcome email upon registration.
* Sends an email with a token to reset password

#### Queue
* Users can add videos to watch later, as well as delete or reorder them

#### People
* Users can create reviews and ratings for videos
* Submitted video reviews immediately display on the page without interrupting video playback
* Users can follow other users so they can view their queues and video reviews
* Users can invite their friends via email through the app. If their friend joins, each user will automatically follow the other.

#### Admin
* Admin can add videos. Video images are uploaded directly to Amazon S3.
* Admin can view user payments

#### Friendly URL's
* SEO and user-friendly URL's in addition to slug history with the friendly_id gem

#### Pagination
* pagination also generates SEO and user-friendly URL's like `/my_resources/page/33` instead of `/my_resources?page=33`
* pagination generated with the kaminari gem works with objects decorated with the draper gem

#### Responsive Design
* Custom CSS in conjunction with Bootstrap makes the app look great on all screen sizes

## Under the Hood

#### Database
* Uses Postgres in development, staging, and production

#### Testing
* Comprehensive unit, controller, and integration test coverage using RSpec and Capybara
* Uses the vcr gem to record api responses
* Uses selenium and poltergeist to process javascript
* Employs stubs and mocks to avoid redundant testing

#### Beyond the Basics
* Service object to push complex registration logic out of controllers
* API wrapper for Stripe
* Webhook processing for Stripe, using stripe-event gem
* Decorators using the draper gem to push view logic out of models
* Advanced search using the Elasticsearch API and the searchkick gem
* Sikdekiq to send emails in background jobs
* File uploading using the shrine gem
* Continuous integration with circleci
