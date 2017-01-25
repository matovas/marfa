require_relative 'base_controller'
require 'marfa/helpers/scss'
require 'marfa/helpers/style'

module Marfa
  module Controllers
    class CssController < BaseController
      helpers Marfa::Helpers::Scss
      include Marfa::Helpers::Style

      get '/css/main.:device.css' do |device|
        render_main_style(device)
      end
    end
  end
end