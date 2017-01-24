require 'ostruct'
require 'marfa/controllers/base_controller'
require 'htmlcompressor'

module Marfa
  # Configuration
  def self.config
    @config ||= OpenStruct.new
  end

  # Configure BaseController - configure Sinatra
  def self.configure_app
    return if @config.to_h.empty?

    _default_settings
    app = Marfa::Controllers::BaseController

    @_default_settings.each do |setting|
      app.set setting.to_sym, Marfa.config[setting] unless Marfa.config[setting].nil?
    end

    app.configure do
      app.use Rack::Csrf, raise: true if Marfa.config.csrf_enabled
      app.use HtmlCompressor::Rack if Marfa.config.compression_enabled
    end
  end

  # Default settings fields for apps
  def self._default_settings
    @_default_settings = [
      'public_folder',
      'static_cache_control',
    ]
  end
end