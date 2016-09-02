# Calendly Version 1.0.0

Instalation
--------------
add to Gemfile

gem 'calendly', git: 'git@github.com:nurdymuny/calendly-ruby.git'

run `bundle install`

set token on config initializers/calendly.rb
http://developer.calendly.com/v1/docs/getting-your-authentication-token

Calendly.configure do |config|
  config.token = put here calendly token
end

Usage
--------------
http://developer.calendly.com

Calendly.test_authentication
http://developer.calendly.com/docs/test-authentication-token

Calendly.webhook_subscription({url: 'url', events: ["invitee.created", "invitee.canceled"]})
http://developer.calendly.com/docs/webhook-subscriptions

Calendly.delete_webhook(hook_id)
http://developer.calendly.com/docs/delete-webhook-subscription

Calendly.sample_invitee
http://developer.calendly.com/docs/invitee-samples

