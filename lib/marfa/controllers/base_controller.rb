require 'haml'
require 'rack/csrf'
require 'device_detector'
require 'marfa/helpers/controller'
require 'marfa/helpers/http/vary'
require 'marfa/helpers/javascript'

# Extending Marfa
module Marfa
  # Extending Controllers
  module Controllers
    # base controller
    class BaseController < Sinatra::Base
      before do
        @device = DeviceDetector.new(request.user_agent).device_type
      end

      # Not Found page
      not_found do
        status 404
        haml :not_found
      end

      # All methods defined below might be used in child controllers
      helpers Marfa::Helpers::Controller
      helpers Marfa::Helpers::HTTP::Vary
      helpers Marfa::Helpers::Javascript
    end
  end
end
