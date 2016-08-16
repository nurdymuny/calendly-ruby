require "calendly/version"
require "calendly/configuration"
require "calendly/error_msg"
require "json"

module Calendly
	CALENDLY_URL = "https://calendly.com/api/v1/"

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
    
    uri = URI("#{CALENDLY_URL}echo")

		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		
		request = Net::HTTP::Get.new(uri.request_uri)
    request["X-TOKEN"] = @configuration.token

		response = http.request(request)

		data = response.body
		response.code.eql?("204") ? {message: 'Authentication valid!'} : JSON.parse(data)
  end
 
  def self.webhook_subscription(params={})
  	checking_token
    uri = URI("#{CALENDLY_URL}hooks")
    # Create the HTTP objects
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE

		request = Net::HTTP::Post.new(uri.request_uri)
    request["X-TOKEN"] = @configuration.token
		request.content_type = "application/json"

		request.body = params.to_json
		# Send the request
		res = http.request(request)

    data = res.body
    JSON.parse(data)
  end

  def self.delete_webhook(hook_id)
    checking_token
    #12400
    uri = URI("#{CALENDLY_URL}hooks/#{hook_id}")
    # Create the HTTP objects
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE

		request = Net::HTTP::Delete.new(uri.request_uri)
    request["X-TOKEN"] = @configuration.token
		request.content_type = "application/json"

		# Send the request
		res = http.request(request)

    data = res.body
    res.code.eql?('200') ? {message: 'Success'} : JSON.parse(data)
  end

  def self.sample_invitee(canceled=false)
    checking_token

    url_text = canceled ? "#{CALENDLY_URL}invitees/samples" : "#{CALENDLY_URL}invitees/samples?canceled=true"

    uri = URI(url_text)

		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		
		request = Net::HTTP::Get.new(uri.request_uri)
    request["X-TOKEN"] = @configuration.token

		response = http.request(request)

		data = response.body
    JSON.parse(data)
  end

  def self.checking_token
    raise Calendly::ErrorMsg.new(msg: "Authentication Token have not yet setup.", error: {status: 202, message: 'Authentication Token have not yet setup'}) unless configured? 
  end

  def self.configured?
    @configuration && !@configuration.token.nil?
  end
end