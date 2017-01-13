require 'ostruct'

module Marfa
  class Configuration
    def config
      @config ||= OpenStruct.new
    end

    def configure
      yield(config)
    end
  end
end