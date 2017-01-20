require 'haml'
require 'rack/csrf'
require 'device_detector'
require 'marfa/configuration'
require 'marfa/helpers/controller'
require 'marfa/helpers/http/vary'

# Extending Marfa
module Marfa
  # Extending Controllers
  module Controllers
    # base controller
    class BaseController < Sinatra::Base
      before do
        @device = DeviceDetector.new(request.user_agent).device_type
      end

      if defined?(Marfa.config)
        set :public_folder, Marfa.config.public_folder
        # cache in browser all files under public folder
        set :static_cache_control, [:public, :max_age => Marfa.config.static_files_cache_lifetime]
        # CSRF protection
        if Marfa.config.csrf_enabled
          p 'csrf enabled'
          configure do
            use Rack::Csrf, raise: true
          end
        end
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
