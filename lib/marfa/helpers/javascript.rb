require 'babel/transpiler'
require 'closure-compiler'

# Javascript
module Marfa
  # Helpers for Javascript
  module Helpers
    # Javascript module
    module Javascript

      def js_transpile( path, is_plain_text = true )

        result = Babel::Transpiler.transform File.read( path ) if is_plain_text == false
        result = Babel::Transpiler.transform( path )           if is_plain_text == true

        result['code']
      end

      # https://developers.google.com/closure/compiler/docs/compilation_levels

      def js_import( path )
        path = settings.views + path

        closure = Closure::Compiler.new(
            :compilation_level => 'SIMPLE_OPTIMIZATIONS',
            :language_out => 'ES5_STRICT'
        )

        a = js_transpile( path, false )

        a = closure.compile(a) if Marfa.config.minify_js
        #b = a unless Marfa.config.minify_js

        '<script>' + a + '</script>'
      end



      # https://developers.google.com/closure/compiler/docs/compilation_levels

      def js_import_from_haml( path )

        closure = Closure::Compiler.new(
            :compilation_level => 'SIMPLE_OPTIMIZATIONS',
            :language_out => 'ES5_STRICT'
        )

        a = haml :"#{ path }", :layout => false
        a = js_transpile( a )
        b = closure.compile(a)
        c = '<script>' + b + '</script>'

        c
      end
    end
  end
end