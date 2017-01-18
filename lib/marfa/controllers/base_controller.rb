require 'haml'
require 'rack/csrf'

# Extending Marfa
module Marfa
  # Extending Controllers
  module Controllers
    # base controller
    class BaseController < Sinatra::Base
      # before do
      #   Marfa.cache = Marfa::Cache.new
      # end
      # enable CSRF protection
      set :public_folder, Marfa.config.public_folder
      set :static_cache_control, [:public, :max_age => Marfa.config.static_files_cache] # cache in browser all files under public folder

      configure do
        use Rack::Csrf, raise: true
      end

      # Not Found page
      not_found do
        status 404
        haml :not_found
      end

      # All methods defined below might be used in child controllers
      # TODO: Move this helpers to separate file
      helpers do
        # Rendering cached content
        # @param cache_key [String] key
        # @param path [String] - URL
        # @param data [Hash] - options hash
        # @example
        #   render_cached_content('some_key', 'path/url', {})
        # @return [String] rendered content
        def render_cached_content(cache_key, path, data = {})
          return Marfa.cache.get(cache_key) if Marfa.cache.exist?(cache_key)
          output = haml :"#{path}", locals: data
          Marfa.cache.set(cache_key, output)
          output
        end

        # Render page from cache, return html
        # @param path [String] - URL
        # @param tags [Array] - tag list
        # @param data [Hash] - options hash
        # @example
        #   render_page('index', ['tag1', 'tag2'], {})
        # @return [String] rendered content
        def render_page(path, tags, data)
          cache_key = Marfa.cache.create_key('page', path, tags)
          full_path = 'pages/' + path
          render_cached_content(cache_key, full_path, data)
        end

        # Render page from cache, store to cache, return html
        # @param kind [String] - kind (block, page)
        # @param path [String] - URL
        # @param tags [Array] - tag list
        # @example
        #   get_cached_content('page', 'index/index', ['tag1', 'tag2'])
        # @return [String] data from cache
        # @return [Nil]
        def get_cached_content(kind, path, tags)
          cache_key = Marfa.cache.create_key(kind, path, tags)
          return Marfa.cache.get(cache_key) if Marfa.cache.exist?(cache_key)
        end

        # Render block from cache, return html
        # @param path [String] - URL
        # @param tags [Array] - tag list
        # @example
        #   render_block('index/index', ['tag1', 'tag2'])
        # @return [String] rendered block
        def render_block(path, tags)
          # TODO: Improve caching with parameters
          content = get_cached_content('block', path, tags)
          return content unless content.nil?

          classname = path.to_class_name + 'Block'
          return unless Object.const_defined?(classname)

          attrs = {
            user_data: @user_data || {},
            query: params.to_h
          }

          block = Object.const_get(classname).new
          data = block.get_data(attrs)
          cache_key = Marfa.cache.create_key('block', path, tags)
          full_path = 'blocks/' + path

          render_cached_content(cache_key, full_path, data)
        end

        # Generate CSRF token
        # @return [String] CSRF token
        def csrf_token
          Rack::Csrf.csrf_token(env)
        end

        # CSRF-tag
        # @return [String] CSRF tag
        def csrf_tag
          Rack::Csrf.csrf_tag(env)
        end

        # Get HTML from cache or render new
        # @param path [String] - URL
        # @param tags [Array] - tag list
        # @param data [Hash] - data to render
        # @example
        #   get_html('index/index', ['tag1', 'tag2'], {})
        # @return [String] HTML
        def get_html(path, tags, data)
          html = get_cached_content('page', path, tags)
          html = render_page(path, tags, data) if html.nil?
          html
        end
      end
    end
  end
end
