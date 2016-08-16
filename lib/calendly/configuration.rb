module Calendly
  class Configuration
  	attr_accessor :token

	  def self.initialize
      @token = nil
	  end
  end
end