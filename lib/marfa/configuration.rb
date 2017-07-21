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
    _configure_settings(Marfa::Controllers::CssController) if Marfa.config.use_css_build
    _configure_ext_modules(Marfa::Controllers::BaseController)
  end

  # Configure Marfa in block
  def self.configure
    config if @config.nil?
    yield @config
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
    opts = Marfa.config.html_compression_options

    app.use Rack::Session::Cookie, key: 'rack.session', secret: Marfa.config.session_secret

    app.configure do
      app.use Rack::Csrf, raise: true if Marfa.config.csrf_enabled
      app.use HtmlCompressor::Rack, opts if opts && opts[:enabled]
    end
  end

  # Default settings fields for apps
  def self._default_settings
    @_default_settings = %w[
      public_folder
      static_cache_control
      views
      environment
      logging
      dump_errors
      show_exceptions
    ]
  end
end