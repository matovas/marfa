require 'ostruct'

module Marfa
  module Configuration
    def config
      @config ||= OpenStruct.new
    end

    def configure
      yield(config)
    end
  end
end