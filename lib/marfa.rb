# encoding: utf-8
require 'sinatra/base'
require 'marfa/configuration'
require 'marfa/cache'
require 'marfa/version'
require 'marfa/controllers/base_controller'
require 'marfa/controllers/css_controller'
require 'marfa/helpers/classes/string'
require 'marfa/helpers/render_style'
require 'marfa/helpers/sass_functions'
require 'marfa/models/base_dto'
require 'marfa/models/base_model'

module Marfa
  # test method
  def self.test
    puts 'it is alive!'
  end
end