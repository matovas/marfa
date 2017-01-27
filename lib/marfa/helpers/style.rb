require 'sass/plugin'
require 'csso'

# Rendering and caching style
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

      # Rendering style
      # @param [Hash] options  - options
      #   available options:
      #   - device - device type
      #   - root_path - root_path to file
      #   - section - category page name
      #   - range - page name
      # @return styles
      def render_style(options)
        return if options[:device].nil?

        root_path = options[:root_path] || '/'

        file_name =
          [options[:section], options[:range], options[:device]]
          .reject { |opt| opt.nil? }
          .join('.') + '.css'

        path = settings.public_folder.to_s + '/css' + root_path + file_name

        scss_path =
          root_path +
          [options[:section], options[:range]]
            .reject { |opt| opt.nil? }
            .join('/')

        if File.exist?(path) && Marfa.config.cache_styles
          send_file(File.join(settings.public_folder.to_s + '/css', File.basename(file_name)), type: 'text/css')
        else
          styles = create_style(scss_path, options[:device])
          File.write(path, styles) if Marfa.config.cache_styles
          content_type 'text/css', charset: 'utf-8', cache: 'false'
          styles
        end
      end

      # Create styles
      # @param [String] scss_path - path to scss file
      # @param [String] device - device type
      def create_style(scss_path, device)
        dynamic_vars(device)

        if Marfa.config.minify_css
          output = scss(:"#{scss_path}", { style: :compressed, cache: false })
          output = Csso.optimize(output)
        else
          output = scss(:"#{scss_path}", { style: :expanded, cache: false })
        end

        output
      end
    end
  end
end