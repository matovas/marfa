require 'fileutils'
require 'rake'

include FileUtils

# Default cache configuration
def create_cache_config_file
  open('config/cache.yml', 'w') do |file|
    file.puts 'enabled: false'
    file.puts "host: 'localhost'"
    file.puts 'port: 6379'
    file.puts 'db: 0'
    file.puts 'expiration_time: 86400'
  end
end

def create_application_config_file
  open('config/application.rb', 'w') do |file|
    file.puts "require 'marfa'"
    file.puts ''
    file.puts "Marfa.config.api_server = ''"
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
    file.puts "require 'config/application.rb'"
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
    mkdir_p(%w(app config app/blocks app/controllers app/models app/views))
    puts 'Project structure are created'

    puts 'Creating config files...'
    create_cache_config_file
    create_application_config_file
    create_rackup_config_file
    puts 'Config files are created'

    puts 'Creating dummy model files...'
    create_base_dto_file
    puts 'Dummy model files are created'
  end
end