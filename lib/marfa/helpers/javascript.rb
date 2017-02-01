require 'babel/transpiler'
require 'closure-compiler'

# TODO: Remove in v0.2

# Javascript
module Marfa
  # Helpers for Javascript
  module Helpers
    # Javascript module
    module Javascript
      def js_transpile(path, is_plain_text = true)
        path = File.read(path) unless is_plain_text
        result = Babel::Transpiler.transform(path)
        result['code']
      end

      # https://developers.google.com/closure/compiler/docs/compilation_levels
      def js_import(path)
        path = settings.views + path

        closure = Closure::Compiler.new(
          compilation_level: 'SIMPLE_OPTIMIZATIONS',
          language_out: 'ES5_STRICT'
        )

        code = js_transpile(path, false)
        code = closure.compile(code) if Marfa.config.minify_js
        '<script>' + code + '</script>'
      end

      # https://developers.google.com/closure/compiler/docs/compilation_levels
      def js_import_from_haml(path, data = {})
        closure = Closure::Compiler.new(
          compilation_level: 'SIMPLE_OPTIMIZATIONS',
          language_out: 'ES5_STRICT'
        )

        template = haml :"#{path}", :layout => false, :locals => data
        code = js_transpile(template)
        code = closure.compile(code)
        '<script>' + code + '</script>'
      end
    end
  end
end