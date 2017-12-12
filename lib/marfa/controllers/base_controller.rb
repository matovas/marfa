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
          client = DeviceDetector.new(request.user_agent)
          @device = client.device_type
          @browser = client.name
          @client_full_version = client.full_version
          @device = Marfa.config.device_detector[:default_device] if @device.nil?
        end

        @css_version = Marfa.css_version
      end

      # Not Found page
      not_found do
        status 404
        template_engine = Marfa.config.template_engine || :haml
        render(template_engine, :not_found)
      end

      # All methods defined below might be used in child controllers
      helpers Marfa::Helpers::Controller
      helpers Marfa::Helpers::HTTP::Vary
    end
  end
end
