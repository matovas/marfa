require 'ostruct'
require 'marfa/controllers/base_controller'
require 'marfa/controllers/css_controller'
require 'htmlcompressor'

module Marfa
  # Configuration
  def self.config
    @config ||= OpenStruct.new
  end

  # Configure BaseController - configure Sinatra
  def self.configure_app
    return if @config.to_h.empty?

    _configure_settings(Marfa::Controllers::BaseController)
    _configure_settings(Marfa::Controllers::CssController)
    _configure_ext_modules(Marfa::Controllers::BaseController)
  end

  private

  # Configure controller settings
  def self._configure_settings(app)
    _default_settings

    @_default_settings.each do |setting|
      app.set setting.to_sym, Marfa.config[setting] unless Marfa.config[setting].nil?
    end
  end

  # Configure extending modules
  def self._configure_ext_modules(app)
    app.configure do
      app.use Rack::Csrf, raise: true if Marfa.config.csrf_enabled
      app.use HtmlCompressor::Rack, Marfa.config.html_compression if Marfa.config.html_compression[:enabled]
    end
  end

  # Default settings fields for apps
  def self._default_settings
    @_default_settings = [
      'public_folder',
      'static_cache_control',
      'views'
    ]
  end
end