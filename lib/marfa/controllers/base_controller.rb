require 'haml'
require 'rack/csrf'
require 'device_detector'
require 'marfa/helpers/controller'
require 'marfa/helpers/http/vary'
require 'marfa/css_version'

# Extending Marfa
module Marfa
  # Extending Controllers
  module Controllers
    # base controller
    class BaseController < Sinatra::Base
      before do
        if Marfa.config.device_detector[:enabled]
          @device = DeviceDetector.new(request.user_agent).device_type
          @device = Marfa.config.device_detector[:default_device] if @device.nil?
        end

        @css_version = Marfa.css_version
      end

      # Not Found page
      not_found do
        status 404
        haml :not_found
      end

      # All methods defined below might be used in child controllers
      helpers Marfa::Helpers::Controller
      helpers Marfa::Helpers::HTTP::Vary
    end
  end
end
