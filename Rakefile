# Warning: this is deprecated and will be removed in 0.2
# TODO: remove in 0.2

require 'fileutils'
require 'rake'
require 'babel/transpiler'
require 'closure-compiler'
require 'marfa/file_templates'

include FileUtils
include Marfa::FileTemplates

def js_transpile(path, is_plain_text = true)
  path = File.read(path) unless is_plain_text
  result = Babel::Transpiler.transform(path)
  result['code']
end

task :default do
  puts 'Please specify command'
end

task :start, [:home_path, :project_dir] do |t, args|
  puts "Deprecation warning: this will be removed in marfa-0.2. Use marfa-start instead."
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

    puts 'Creating config files...'

    project_path = "#{args[:home_path]}/#{project_dir}"

    marfa_rb(project_path)
    application_rb(project_path)
    bootstrap_rb(project_path)
    config_ru(project_path)

    puts 'Config files are created'
  end
end

task :transpile_js, [:home_path, :search_dir, :output_dir] do |t, args|
  puts "Deprecation warning: this will be removed in marfa-0.2. Use marfa-build-js instead."
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
