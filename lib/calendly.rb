# frozen_string_literal: true

require 'calendly/version'
require 'calendly/configuration'
require 'calendly/error_msg'
require 'net/http'
require 'json'

module Calendly
  CALENDLY_URL = 'https://calendly.com/api/v1/'

  class << self
    attr_writer :configuration, :url
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.test_authentication
    checking_token

    url = "#{CALENDLY_URL}echo"

    response = request(url, 'get')
    data = response.body
    response.code.eql?('204') ? { message: 'Authentication valid!' } : JSON.parse(data)
  end

  def self.webhook_subscription(params = {})
    checking_token
    url = "#{CALENDLY_URL}hooks"

    res = request(url, 'post', params)

    data = res.body
    JSON.parse(data)
  end

  def self.webhook_subscriptions
    checking_token
    url = "#{CALENDLY_URL}hooks"

    res = request(url, 'get')

    data = res.body
    JSON.parse(data)
  end

  def self.delete_webhook(hook_id)
    checking_token
    url = "#{CALENDLY_URL}hooks/#{hook_id}"

    res = request(url, 'delete')

    data = res.body
    res.code.eql?('200') ? { message: 'Success' } : JSON.parse(data)
  end

  def self.sample_invitee(canceled = false)
    checking_token

    url_text = canceled ? "#{CALENDLY_URL}invitees/samples" : "#{CALENDLY_URL}invitees/samples?canceled=true"

    response = request(url_text, 'get')

    data = response.body
    JSON.parse(data)
  end

  def self.request(url, req_type, params = {})
    uri = URI(url)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = eval "Net::HTTP::#{req_type.capitalize}.new(uri.request_uri)"
    request['X-TOKEN'] = @configuration.token
    request.content_type = 'application/json'
    request.body = params.to_json if params.any?

    http.request(request)
  end

  def self.configured?
    @configuration && !@configuration.token.nil?
  end

  private

  def self.checking_token
    raise Calendly::ErrorMsg.new(msg: 'Authentication Token have not yet setup.', error: { status: 202, message: 'Authentication Token have not yet setup' }) unless configured?
  end
end
