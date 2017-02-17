require 'marfa/configuration'

module Marfa
  module Helpers
    module Controller

      def render_content(path, data)
        haml :"#{path}", locals: data
      end

      # Rendering cached content
      # @param cache_key [String] key
      # @param path [String] - URL
      # @param data [Hash] - options hash
      # @example
      #   render_cached_content('some_key', 'path/url', {})
      # @return [String] rendered content
      def render_cached_content(cache_key, path, data = {}, cache_time = Marfa.config.cache[:expiration_time])
        return Marfa.cache.get(cache_key) if Marfa.cache.exist?(cache_key)
        output = render_content(path, data)
        Marfa.cache.set(cache_key, output, cache_time)
        output
      end

      # Render page from cache, return html
      # @param path [String] - URL
      # @param tags [Array] - tag list
      # @param data [Hash] - options hash
      # @example
      #   render_page('index', ['tag1', 'tag2'], {})
      # @return [String] rendered content
      def render_page(path, tags, data, cache_time = Marfa.config.cache[:expiration_time])
        full_path = 'pages/' + path
        return render_content(full_path, data) if cache_time == 0

        cache_key = Marfa.cache.create_key('page', path, tags)
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
      def get_cached_content(kind, path, tags = [])
        cache_key = Marfa.cache.create_key(kind, path, tags)
        return Marfa.cache.get(cache_key) if Marfa.cache.exist?(cache_key)
      end

      # Render block from cache, return html
      # @param path [String] - URL
      # @param tags [Array] - tag list
      # @param query [Hash] - query params
      # @param class_name [String] - class name to block
      # @example
      #   render_block('index/index', ['tag1', 'tag2'])
      # @return [String] rendered block
      def render_block(path, tags = [], query = {}, class_name = nil, cache_time = Marfa.config.cache[:expiration_time])
        # TODO: Improve caching with parameters
        if cache_time > 0
          content = get_cached_content('block', path, tags)
          return content unless content.nil?
        end

        classname = class_name || (path.to_class_name + 'Block')
        return unless Object.const_defined?(classname)

        attrs = {
          user_data: @user_data || {},
          query: query
        }

        block = Object.const_get(classname).new
        data = block.get_data(attrs)


        full_path = Marfa.config.block_templates_path + '/' + path

        return render_content(full_path, data) if cache_time == 0

        cache_key = Marfa.cache.create_key('block', path, tags)
        render_cached_content(cache_key, full_path, data)
      end

      # Render block from cache, return html without class eval
      # @param path [String] - URL
      # @param data [Hash] - data to render
      # @example
      #   render_static_block('index/index', ['tag1', 'tag2'])
      # @return [String] rendered block
      def render_static_block(path, data = {})
        content = get_cached_content('block', path)
        return content unless content.nil?

        cache_key = Marfa.cache.create_key('block', path)
        full_path = Marfa.config.block_templates_path + '/' + path

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
      def get_html(path, tags, data, cache_time = Marfa.config.cache[:expiration_time])
        if cache_time > 0
          html = get_cached_content('page', path, tags)
          html = render_page(path, tags, data, cache_time) if html.nil?
        else
          html = render_page(path, tags, data, cache_time)
        end
        html
      end

      alias_method :render_component, :render_block
      alias_method :render_static_component, :render_static_block
    end
  end
end