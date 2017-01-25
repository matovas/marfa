require 'marfa/controllers/base_controller'
require 'marfa/controllers/css_controller'

module Marfa
  module Controllers
    # Controllers for Rack run
    # @return [Array] Controllers list
    def self.controllers_list
      @controllers_list = [
        CssController
      ]
    end
  end
end