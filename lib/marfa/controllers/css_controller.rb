require_relative 'base_controller'
require 'marfa/helpers/scss'
require 'marfa/helpers/style'

module Marfa
  module Controllers
    class CssController < BaseController
      helpers Marfa::Helpers::Scss
      include Marfa::Helpers::Style

      get '/css/main.:device.css' do |device|
        render_style({ section: 'main', device: device })
      end

      get '/css/:section.:range.:device.css' do |section, range, device|
        render_style({ root_path: '/pages/', section: section, range: range, device: device })
      end
    end
  end
end