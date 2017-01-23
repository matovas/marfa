require 'ostruct'
require 'marfa/controllers/base_controller'

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

    if Marfa.config.csrf_enabled
      p 'CSRF enabled'
      app.configure do
        app.use Rack::Csrf, raise: true
      end
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