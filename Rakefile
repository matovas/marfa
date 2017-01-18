require 'fileutils'
require 'rake'

include FileUtils

# Default marfa configuration
def create_marfa_config_file
  open('config/marfa.rb', 'w') do |file|
    file.puts '# Marfa configuration file'
    file.puts ''
    file.puts '# Specifying API Server is needed'
    file.puts "Marfa.config.api_server = ''"
    file.puts ''
    file.puts '# Cache config'
    file.puts "Marfa.config.cache = {"
    file.puts '  enabled: false,'
    file.puts "  host: '',"
    file.puts '  port: 0,'
    file.puts '  db: 0,'
    file.puts '  expiration_time: 3600,'
    file.puts '}'
    file.puts ''
    file.puts '# public folder'
    file.puts "Marfa.config.public_folder = File.dirname(__FILE__) + '/static'"
    file.puts ''
    file.puts '# Static files config'
    file.puts "Marfa.config.static_files_cache_lifetime = 604800"
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
    file.puts '# Controllers auto-bootstrap'
    file.puts "controllers = Object.constants.select { |c| c.to_s.include? 'Controller' }"
    file.puts "controllers.map! { |controller| Object.const_get(controller) }"
    file.puts "run Rack::Cascade.new(controllers)"
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
