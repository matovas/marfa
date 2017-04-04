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
      # @param options [Hash] - options hash
      # @example
      #   render_page({ path: 'index', tags: ['tag1', 'tag2'], data: {} })
      # @return [String] rendered content
      def render_page(options)
        cache_time = options[:cache_time] || Marfa.config.cache[:expiration_time]

        kind = 'page'
        kind += "-#{@device}" if Marfa.config.cache[:use_device]

        full_path = 'pages/' + options[:path]
        return render_content(full_path, options[:data]) if cache_time == 0

        cache_key = Marfa.cache.create_key(kind, options[:path], options[:tags])
        render_cached_content(cache_key, full_path, options[:data])
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
        nil
      end

      # Render block from cache, return html
      # @param options [Hash] - options hash
      # @example
      #   render_block({ path: 'index/index', tags: ['tag1', 'tag2'] })
      # @return [String] rendered block
      def render_block(options)
        # TODO: Improve caching with parameters
        cache_time = options[:cache_time] || Marfa.config.cache[:expiration_time]
        tags = options[:tags] || []

        kind = 'block'
        kind += "-#{@device}" if Marfa.config.cache[:use_device]

        if cache_time > 0
          content = get_cached_content(kind, options[:path], tags)
          return content unless content.nil?
        end

        classname = options[:class_name] || (options[:path].to_class_name + 'Block')
        return unless Object.const_defined?(classname)

        attrs = {
          user_data: @user_data || {},
          query: options[:query] || {}
        }

        block = Object.const_get(classname).new
        data = block.get_data(attrs)
        full_path = Marfa.config.block_templates_path + '/' + options[:path]

        return render_content(full_path, data) if cache_time == 0

        cache_key = Marfa.cache.create_key(kind, options[:path], tags)
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
      # @param options [Hash] - params
      # @example
      #   get_html({ path: 'index', tags: ['tag1', 'tag2'], data: {} })
      # @return [String] HTML
      # def get_html(path, tags, data, cache_time = Marfa.config.cache[:expiration_time])
      def get_html(options)
        cache_time = options[:cache_time] || Marfa.config.cache[:expiration_time]

        if cache_time > 0
          kind = 'page'
          kind += "-#{@device}" if Marfa.config.cache[:use_device]

          html = get_cached_content(kind, options[:path], options[:tags])
          html = render_page(options) if html.nil?
        else
          html = render_page(options)
        end
        html
      end

      alias_method :render_component, :render_block
      alias_method :render_static_component, :render_static_block
    end
  end
end