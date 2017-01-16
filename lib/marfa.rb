require 'sinatra/base'
require 'ostruct'
require 'marfa/cache'
require 'marfa/version'
require 'marfa/controllers/base_controller'
require 'marfa/helpers/classes/string'
require 'marfa/helpers/render_style'
require 'marfa/helpers/sass_functions'
require 'marfa/models/base_dto'
require 'marfa/models/base_model'

# requires all submodules
module Marfa
  # Configuration
  def self.config
    @config ||= OpenStruct.new
  end

  # Returns Cache instance
  def self.cache
    @cache ||= Marfa::Cache.new
  end

end