# encoding: utf-8
require_relative 'base_controller'

# Extending Marfa
module Marfa
  # Extending Controllers
  module Controllers
    # CSS-controllers
    class CssController < BaseController
      # css route
      get '/css/main.:device.css' do |device|
        render_main_style(device)
      end
    end
  end
end
