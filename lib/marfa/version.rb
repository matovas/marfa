# Version constant
module Marfa
  # The version constant for the current version of Marfa
  VERSION = '0.5.2' unless defined?(Marfa::VERSION)

  # The current Marfa version.
  # @return [String] The version number
  def self.version
    VERSION
  end
end
