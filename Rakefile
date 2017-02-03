require 'fileutils'
require 'rake'
require 'babel/transpiler'
require 'closure-compiler'
# require 'sass/plugin'
# require 'sass/engine'
# require 'csso'
include FileUtils

# Default marfa configuration
def create_marfa_config_file
  open('config/marfa.rb', 'w') do |file|
    file.puts '# Marfa configuration file'
    file.puts ''
    file.puts '# Specifying API Server is needed'
    file.puts "Marfa.config.api_server = ''"
    file.puts ''
    file.puts '# Views path is needed'
    file.puts "Marfa.config.views = File.expand_path('./app/views')"
    file.puts ''
    file.puts '# Cache config'
    file.puts "Marfa.config.cache = {"
    file.puts '  enabled: false,'
    file.puts "  host: '',"
    file.puts '  port: 0,'
    file.puts '  db: 0,'
    file.puts '  expiration_time: 3600'
    file.puts '}'
    file.puts ''
    file.puts '# Static files content path'
    file.puts "Marfa.config.content_path = '/images/content/'"
    file.puts ''
    file.puts 'Marfa.config.cache_styles = true'
    file.puts ''
    file.puts '# Public folder'
    file.puts "Marfa.config.public_folder = File.expand_path('./static')"
    file.puts ''
    file.puts '# Static files cache'
    file.puts "Marfa.config.static_cache_control = [:public, :max_age => 2_592_000]"
    file.puts ''
    file.puts '# CSRF Protection'
    file.puts 'Marfa.config.csrf_enabled = false'
    file.puts ''
    file.puts '# HTML Compression'
    file.puts 'Marfa.config.html_compression_options = {'
    file.puts ':enabled => true,
  :remove_multi_spaces => true,
  :remove_comments => true,
  :remove_intertag_spaces => false,
  :remove_quotes => true,
  :compress_css => false,
  :compress_javascript => false,
  :simple_doctype => false,
  :remove_script_attributes => true,
  :remove_style_attributes => true,
  :remove_link_attributes => true,
  :remove_form_attributes => false,
  :remove_input_attributes => true,
  :remove_javascript_protocol => true,
  :remove_http_protocol => false,
  :remove_https_protocol => false,
  :preserve_line_breaks => false,
  :simple_boolean_attributes => true'
    file.puts '}'
    file.puts ''
    file.puts '# CSS Minifying'
    file.puts 'Marfa.config.minify_css = true'
    file.puts ''
    file.puts '# JS Minifying'
    file.puts 'Marfa.config.minify_js = true'
  end
end

def create_application_config_file
  open('config/application.rb', 'w') do |file|
    # file.puts "require 'marfa'"
    # file.puts ''
  end
end

# Default DTO file
def create_base_dto_file
  open('app/models/dto.rb', 'w') do |file|
    file.puts "require 'marfa'"
    file.puts ''
    file.puts 'class DTO < Marfa::Models::BaseDTO'
    file.puts 'end'
  end
end

# Rackup file
def create_rackup_config_file
  open('config.ru', 'w') do |file|
    file.puts "require 'marfa'"
    file.puts "require File.dirname(__FILE__) + '/app/bootstrap'"
    file.puts "require File.dirname(__FILE__) + '/config/marfa'"
    file.puts ''
    file.puts 'Marfa.configure_app'
    file.puts ''
    file.puts '# Controllers auto-bootstrap'
    file.puts "controllers = Object.constants.select { |c| c.to_s.include? 'Controller' }"
    file.puts 'controllers.map! { |controller| Object.const_get(controller) }'
    file.puts 'controllers += Marfa::Controllers.controllers_list'
    file.puts 'run Rack::Cascade.new(controllers)'
  end
end

def create_bootstrap_file
  open('app/bootstrap.rb', 'w') do |file|
    file.puts "require File.dirname(__FILE__) + '/models/dto'"
    file.puts ''
    file.puts '# requiring all blocks and controllers'
    file.puts "Dir[File.dirname(__FILE__) + '/blocks/**/*.rb'].each { |file| require file }"
    file.puts "Dir[File.dirname(__FILE__) + '/controllers/**/*.rb'].each { |file| require file }"
  end
end

def js_transpile(path, is_plain_text = true)
  path = File.read(path) unless is_plain_text
  result = Babel::Transpiler.transform(path)
  result['code']
end

# def device_names
#   [
#     'desktop',
#     'smartphone',
#     'tablet',
    # 'feature phone',
    # 'console',
    # 'tv',
    # 'car browser',
    # 'smart display',
    # 'camera',
    # 'portable media player',
    # 'phablet'
  # ]
# end

# Create styles
# @param [String] scss_path - path to scss file
# @param [String] device - device type
# def create_style(scss_path, device)
#   dynamic_vars(device)
#   template = File.read(scss_path)
#   sass_engine = Sass::Engine.new(template, {syntax: :scss})
#   output = sass_engine.render
#   p output
#   Csso.optimize(output)
# end
#
#
# def dynamic_vars(device, section = 'root')
#   Sass::Plugin.options[:custom] ||= {}
#   Sass::Plugin.options[:custom][:device] = device
#   Sass::Plugin.options[:custom][:section] = section
#   # Sass::Plugin.options[:custom][:contentPath] = Marfa.config.content_path
# end

task :default do
  puts 'Please specify command'
end

task :start, [:home_path, :project_dir] do |t, args|
  project_dir = args[:project_dir]

  puts "Starting project #{project_dir}"
  cd args[:home_path], verbose: true

  unless Dir.exist?(project_dir)
    puts 'Creating project folder...'

    mkdir_p(project_dir)
    cd project_dir, verbose: true

    puts 'Creating project structure...'
    mkdir_p(%w(app config static app/blocks app/controllers app/models app/views))
    puts 'Project structure are created'

    puts 'Creating dummy model files...'
    create_base_dto_file
    puts 'Dummy model files are created'

    puts 'Creating config files...'
    create_marfa_config_file
    create_application_config_file
    create_bootstrap_file
    create_rackup_config_file
    puts 'Config files are created'
  end
end

task :transpile_js, [:home_path, :search_dir, :output_dir] do |t, args|
  puts 'Starting js transpile'

  cd args[:home_path] + args[:search_dir], verbose: true

  search_dir = args[:search_dir] || ''
  output_dir = args[:output_dir] || '/static/js'

  cd args[:home_path] + search_dir, verbose: true

  Dir[args[:home_path] + search_dir + '/**/*.js'].each do |path|
    puts "Processing #{path}"

    closure = Closure::Compiler.new(
      compilation_level: 'SIMPLE_OPTIMIZATIONS',
      language_out: 'ES5_STRICT'
    )

    code = js_transpile(path, false)
    code = closure.compile(code)
    output_path = args[:home_path] + output_dir
    mkdir_p(output_path) unless Dir.exist?(output_path)

    File.open(output_path + '/' + path.split('/').last, 'w') do |f|
      f.puts code
    end
  end

end

# task :compile_css, [:home_path, :search_dir, :output_dir] do |t, args|
#   search_dir = args[:search_dir] || ''
#   output_dir = args[:output_dir] || '/static/css'
#
#   Dir[args[:home_path] + search_dir + '/**/*.scss'].each do |path|
#     puts "Processing #{path}"
#
#     output_path = args[:home_path] + output_dir
#     mkdir_p(output_path) unless Dir.exist?(output_path)
#
#     device_names.each do |device|
#       full_path =
#         output_path +
#         '/' +
#         path.split('/')
#         .last
#         .gsub('scss', '') +
#         "#{device}.css"
#
#       styles = create_style(path, device)
#       File.write(full_path, styles)
#     end
#
#   end
#
# end
