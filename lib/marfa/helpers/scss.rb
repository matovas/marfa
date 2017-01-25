# Sinatra SCSS customization
module Marfa
  # Helpers for SCSS customization
  module Helpers
    # SCSS module
    module Scss
      # Overwrite the find_template method
      def find_template(views, name, engine, &block)
        Array(views).each { |v| super(v, name, engine, &block) }
      end

      # def scss(template, options = {}, locals = {})
        # template = :"#{settings.views}/#{template}" if template.is_a? Symbol
        # super(template, options, locals)
      # end
    end
  end
end