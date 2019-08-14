# frozen_string_literal: true

module Calendly
  class Configuration
    attr_accessor :token

    def self.initialize
      @token = nil
    end

    def self.test_token
      'IOINHFDPPCOBKUHHAVZQT4LGTVELZBWU'
    end
  end
end
