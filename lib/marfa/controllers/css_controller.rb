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

      get '/css/:section.:range.:device.css' do |section, range, device|
        render_page_style(section, range, device)
      end
    end
  end
end