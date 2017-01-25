require 'sass/plugin'
require 'csso'

module Marfa
  module Helpers
    module Style
      # Pass dynamic vars to sass-files
      # @param device [String] - device type
      # @param section [String] - section
      def dynamic_vars(device, section = 'root')
        Sass::Plugin.options[:custom] ||= {}
        Sass::Plugin.options[:custom][:device] = device
        Sass::Plugin.options[:custom][:section] = section
        Sass::Plugin.options[:custom][:contentPath] = Marfa.config.content_path
      end

      # Rendering main styles
      # @param device [String] - device type
      # @return [String] - styles
      def render_main_style(device)
        name = 'main.' + device.to_s + '.css'
        path = settings.public_folder.to_s + '/css/' + name

        if File.exist?(path) && Marfa.config.cache_styles
          send_file(File.join(settings.public_folder.to_s + '/css', File.basename(name)), type: 'text/css')
        else
          styles = create_main_styles(device, minify = Marfa.config.minify_css)
          File.write(path, styles) if Marfa.config.cache_styles && ENV['PLACE'] != 'heroku'
          content_type 'text/css', charset: 'utf-8', cache: 'false'
          styles
        end
      end

      # Creating styles to main page
      # @param device [String] - device type
      # @param minify [Boolean] - add minifying
      # @return [String] - styles
      def create_main_styles(device, minify = false)
        dynamic_vars(device)

        if minify
          output = scss(:'/main', { style: :compressed, cache: false })
          output = Csso.optimize(output)
        else
          output = scss(:'/main', { style: :expanded, cache: false })
        end

        output
      end

    end
  end
end