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

# Specifying API Server is needed
Marfa.config.api_server = ''

# Views path is needed
Marfa.config.views = File.expand_path('./app/views')

# Cache config
Marfa.config.cache = {
  enabled: false,
  host: '',
  port: 0,
  db: 0,
  expiration_time: 3600
}

# Static files content path
Marfa.config.content_path = '/images/content/'

Marfa.config.cache_styles = true

# Public folder
Marfa.config.public_folder = File.expand_path('./static')

# Static files cache
Marfa.config.static_cache_control = [:public, max_age: 2_592_000]

# CSRF Protection
Marfa.config.csrf_enabled = false

# HTML Compression
Marfa.config.html_compression_options = {
  enabled: true,
  remove_multi_spaces: true,
  remove_comments: true,
  remove_intertag_spaces: false,
  remove_quotes: true,
  compress_css: false,
  compress_javascript: false,
  simple_doctype: false,
  remove_script_attributes: true,
  remove_style_attributes: true,
  remove_link_attributes: true,
  remove_form_attributes: false,
  remove_input_attributes: true,
  remove_javascript_protocol: true,
  remove_http_protocol: false,
  remove_https_protocol: false,
  preserve_line_breaks: false,
  simple_boolean_attributes: true
}

# CSS Minifying
Marfa.config.minify_css = true

# JS Minifying
Marfa.config.minify_js = true
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
        file.puts "require 'marfa'
require File.dirname(__FILE__) + '/app/bootstrap'
require File.dirname(__FILE__) + '/config/marfa'

Marfa.configure_app

# Controllers auto-bootstrap
controllers = Object.constants.select { |c| c.to_s.include? 'Controller' }
controllers.map! { |controller| Object.const_get(controller) }
controllers += Marfa::Controllers.controllers_list

run Rack::Cascade.new(controllers)
      "
      end

    end

  end
end