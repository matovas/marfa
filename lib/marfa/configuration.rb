require 'ostruct'

module Marfa
  # Configuration
  def self.config
    @config ||= OpenStruct.new
  end
end