# This module contains file templates for generate new project structure
module Marfa
  module FileTemplates
    # generates content for 'config/application.rb' file
    # @param [String] project_path - path to create_file
    def application_rb(project_path)
      File.open("#{project_path}/config/application.rb", 'w') do |file|
        file.puts ''
      end
    end

    # generates content for 'config/marfa.rb' file
    # @param [String] project_path - path to create_file
    def marfa_rb(project_path)
      File.open("#{project_path}/config/marfa.rb", 'w') do |file|
        file.puts "# Marfa configuration file
Marfa.configure do |cfg|
  # Environment
  cfg.environment = :development
  # Request logging
  cfg.logging = true
  # Logging level 0 - disabled; 1 - small; 2 - all
  cfg.logging_level = 0
  $logger.level = Logger::INFO
  $logger.datetime_format = '%d/%b/%Y:%H:%M:%S %z'
  # Show error page with backtrace
  cfg.show_exceptions = true
  # log exception backtraces to STDERR
  cfg.dump_errors = true

  # Mode (not implemented yet)
  cfg.mode = 'api'

  # Specifying API Server is needed
  cfg.api_server = ''

  # Paths settings
  cfg.content_path = '/images/content/'
  cfg.public_folder = File.expand_path('./static')
  cfg.views = File.expand_path('./app/views')
  cfg.block_templates_path = 'blocks'

  # Redis cache settings
  cfg.cache = {
    enabled: false,
    host: 'localhost',
    port: 6379,
    db: 0,
    expiration_time: 86_400
  }

  # Cache header
  cfg.static_cache_control = [public, max_age: 0]

  # CSS build
  cfg.use_css_build = false

  # CSS file cache
  cfg.cache_styles = false

  # CSRF protection
  cfg.csrf_enabled = false

  # HTML compression
  cfg.html_compression_options = {
    enabled: true,
    remove_intertag_spaces: true
  }

  # CSS/JS Minifying
  cfg.minify_css = false
  cfg.minify_js = true

  # Email settings
  cfg.email = {
    default: {
      address: '',
      port: '587',
      enable_starttls_auto: true,
      user_name: '',
      password: '',
      authentication: :plain,
      domain: 'localhost.localdomain'
    }
  }

  # Device detector
  cfg.device_detector = {
    enabled: true
  }

  # Pagination default template
  cfg.pagination_template = '/pagination'

  # Rack::Session secret
  cfg.session_secret = 'secret'
end

      "
      end
    end

    # content for 'app/bootstrap.rb'
    # @param [String] project_path - path to create_file
    def bootstrap_rb(project_path)
      File.open("#{project_path}/app/bootstrap.rb", 'w') do |file|
        file.puts "require './config/application'

# requiring all blocks and controllers
Dir[File.dirname(__FILE__) + '/blocks/**/*.rb'].each { |file| require file }
Dir[File.dirname(__FILE__) + '/controllers/**/*.rb'].each { |file| require file }
      "
      end
    end

    # content for 'config.ru' file
    # @param [String] project_path - path to create_file
    def config_ru(project_path)
      File.open("#{project_path}/config.ru", 'w') do |file|
        file.puts "Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

require 'marfa'
require File.dirname(__FILE__) + '/app/bootstrap'
require File.dirname(__FILE__) + '/config/marfa/' + ENV['RACK_ENV']
require 'pp' if ENV['RACK_ENV'] == 'production'

p Using config #{File.dirname(__FILE__) + '/config/marfa/' + ENV['RACK_ENV']}

Marfa.configure_app

# Controllers auto-bootstrap
controllers = Object.constants.select { |c| c.to_s.include? 'Controller' }
controllers.map! { |controller| Object.const_get(controller) }
# controllers += Marfa::Controllers.controllers_list

app_map = {
  # '.css': CssController,
  '/': IndexController
}

run Rack::AppMapper.new(controllers, app_map)
      "
      end

    end

  end
end