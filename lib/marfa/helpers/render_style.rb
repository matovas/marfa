# encoding: utf-8
require 'sass/plugin'

# Pass dynamic vars to sass-files
# @param device [String] - device type
# @param section [String] - section
def dynamic_vars(device, section = 'root')
  Sass::Plugin.options[:custom] ||= {}
  Sass::Plugin.options[:custom][:device] = device
  Sass::Plugin.options[:custom][:section] = section
  Sass::Plugin.options[:custom][:contentPath] = $content_path
end

# Creating styles to main page
# @param device [String] - device type
# @param minify [Boolean] - add minifying
# @return [String] - styles
def create_main_styles(device, minify = false)
  dynamic_vars(device)

  if minify
    output = scss(:'/main', { style: :compressed, cache: false })
    output = csso(output)
  else
    output = scss(:'/main', { style: :expanded, cache: false })
  end

  output
end

# Style rendering
# @param device [String] - device type
# @param range [String] - range
# @param section [String] - section
# @return [String] - styles
def render_style_pages(device, range, section)
  name = section.to_s + '_' + range.to_s + '_' + device.to_s + '.css'
  path = settings.public_folder.to_s + '/css/' + name

  if File.exist?(path) && $cache_styles
    send_file(File.join(settings.public_folder.to_s + '/css', File.basename(name)), type: 'text/css')
  else
    styles = create_page_styles(section, range, device)
    File.write(path, styles) if $cache_styles && ENV['PLACE'] != 'heroku'
    content_type 'text/css', charset: 'utf-8', cache: 'false'
    styles
  end
end

# Rendering main styles
# @param device [String] - device type
# @return [String] - styles
def render_main_style(device)
  name = 'main.' + device.to_s + '.css'
  path = settings.public_folder.to_s + '/css/' + name

  if File.exist?(path) && $cache_styles
    send_file(File.join(settings.public_folder.to_s + '/css', File.basename(name)), type: 'text/css')
  else
    styles = create_main_styles(device)
    File.write(path, styles) if $cache_styles && ENV['PLACE'] != 'heroku'
    content_type 'text/css', charset: 'utf-8', cache: 'false'
    styles
  end
end
