# frozen_string_literal: true

require 'spec_helper'

describe Calendly do
  it 'has a version number' do
    expect(Calendly::VERSION).not_to be nil
  end
end

describe '#configure' do
  before do
    Calendly.configure do |config|
      config.token = Calendly::Configuration.test_token
    end
  end

  it 'Test authentication valid' do
    test_auth = Calendly.test_authentication
    expect(test_auth[:message]).to eq('Authentication valid!')
  end

  it 'Test authentication invalid' do
    Calendly.configure do |config|
      config.token = 'wrong token'
    end

    test_auth = Calendly.test_authentication
    expect(test_auth['message']).to eq('Invalid token')
  end

  it 'Webhook subscription' do
    hook = Calendly.webhook_subscription(url: "http://testing#{Time.now.to_i}.com", events: ['invitee.created'])
    expect(hook).to have_key('id')
  end

  it 'Delete webhook' do
    hook = Calendly.webhook_subscription(url: "http://testing#{Time.now.to_i}.com", events: ['invitee.created'])
    delete = Calendly.delete_webhook(hook['id'])
    expect(delete[:message]).to eq('Success')
  end
end
