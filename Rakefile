require 'fileutils'
require 'rake'

include FileUtils

task :default do
  puts 'Please specify command'
end

task :start, [:home_path, :project_dir] do |t, args|
  project_dir = args[:project_dir]

  puts "starting project #{project_dir}"

  cd args[:home_path], verbose: true

  unless Dir.exist?(project_dir)
    puts 'Creating project folder...'

    mkdir_p(project_dir)
    cd project_dir, verbose: true

    puts 'Create project structure...'

    # mkdir_p('app')
    # mkdir_p('config')

    mkdir_p(%w(app config))

    cd 'app', verbose: true

    mkdir_p(%w(blocks controllers models views))

    puts 'Project structure created'

    # mkdir_p('blocks')
    # mkdir_p('controllers')
    # mkdir_p('models')
    # mkdir_p('views')
  end
end