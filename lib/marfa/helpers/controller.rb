require 'marfa/configuration'

module Marfa
  module Helpers
    module Controller
      # DEFAULT_CACHE_TIME = Marfa.config.cache[:expiration_time] unless Marfa.respond_to?(:config)

      # Render content
      # @param path [String] - URL
      # @param data [Hash] - options hash
      # @example
      #   render_content('some_key', 'path/url', {})
      # @return [String] rendered content
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

        # kind = 'page'
        # kind += "-#{@device}" if Marfa.config.cache[:use_device]

        full_path = 'pages/' + options[:path]
        return render_content(full_path, options[:data]) if cache_time.zero?

        # cache_key = Marfa.cache.create_key(kind, options[:path], options[:tags])
        render_cached_content(options[:cache_key], full_path, options[:data])
      end

      # Render page from cache, store to cache, return html
      # @param cache_key [String] - cache key
      # @example
      #   get_cached_content('page', 'index/index', ['tag1', 'tag2'])
      # @return [String] data from cache
      # @return [Nil]
      def get_cached_content(cache_key)
        return Marfa.cache.get(cache_key) if Marfa.cache.exist?(cache_key)
        nil
      end

      # convert query json to tags
      # @param query [Hash] - hash of params
      # @return [Array] of strings key-value or []
      def query_to_tags(query)
        result = []
        if query.is_a? Hash
          query.each { |key, value| result << "#{key}-#{value}" }
        end
        result
      end

      # Render block from cache, return html
      # @param options [Hash] - options hash
      # @example
      #   render_block({ path: 'index/index', tags: ['tag1', 'tag2'] })
      # @return [String] rendered block
      def render_block(options)
        pp options[:path]
        pp options[:query]
        pp options[:cache_block]
        pp options[:cache_key]
        # cache_time = options[:cache_time] || Marfa.config.cache[:expiration_time]
        cache_block = options[:cache_block]
        # tags = options[:tags] || []

        # kind = 'block'
        # kind += "-#{@device}" if Marfa.config.cache[:use_device]
        # tags += query_to_tags(options[:query])

        # if cache_time > 0
        if cache_block
          content = get_cached_content(options[:cache_key])
          return content unless content.nil?
        end

        classname = options[:class_name] || (options[:path].to_class_name + 'Block')
        return unless Object.const_defined?(classname)

        attrs = {
          user_data: @user_data || {},
          query: options[:query] || {},
          locals: options[:locals] || {}
        }

        block = Object.const_get(classname).new
        data = block.get_data(attrs)
        data = data.merge(options[:locals]) unless options[:locals].nil?

        full_path = Marfa.config.block_templates_path + '/' + options[:path]

        return render_content(full_path, data) unless cache_block

        # cache_key = Marfa.cache.create_key(kind, options[:path], tags)
        render_cached_content(options[:cache_key], full_path, data)
      end

      # Render block from cache, return html without class eval
      # @param path [String] - URL
      # @param data [Hash] - data to render
      # @example
      #   render_static_block('index/index', ['tag1', 'tag2'])
      # @return [String] rendered block
      # def render_static_block(path, data = {})
      #   content = get_cached_content('block', path)
      #   return content unless content.nil?
      #
      #   cache_key = Marfa.cache.create_key('block', path)
      #   full_path = Marfa.config.block_templates_path + '/' + path
      #
      #   render_cached_content(cache_key, full_path, data)
      # end

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
      def get_html(options)
        cache_time = options[:cache_time] || Marfa.config.cache[:expiration_time]

        if cache_time > 0
          # kind = 'page'
          # kind += "-#{@device}" if Marfa.config.cache[:use_device]
          # @todo: добавлять-таки сюда к cache_key "page:"
          html = get_cached_content(options[:cache_key])
          html = render_page(options) if html.nil?
        else
          html = render_page(options)
        end
        html
      end

      # Render pagination panel
      # @param data [Hash] - pages info data
      # @param template [String] - template to render
      # @return [String] HTML
      def render_pagination(data, template = nil)
        template ||= Marfa.config.pagination_template
        haml :"#{template}", locals: data
      end

      # Render block with data from cache, return html
      # @param options [Hash] - options hash
      # @example
      #   render_block_with_data({ path: 'index/index', tags: ['tag1', 'tag2'] })
      # @return [String] rendered block
      def render_block_with_data(options)
        pp options[:path]
        pp options[:query]
        pp options[:cache_block]
        pp options[:cache_key]
        cache_block = options[:cache_block]
        # cache_time = options[:cache_time] || Marfa.config.cache[:expiration_time]
        # tags = options[:tags] || []
        #
        # kind = 'block'
        # kind += "-#{@device}" if Marfa.config.cache[:use_device]
        # tags += query_to_tags(options[:query])
        # @todo: добавлять-таки сюда к cache_key "block:"
        # if cache_time.positive?
        if cache_block
          content = get_cached_content(options[:cache_key])
          return content unless content.nil?
        end

        data = options[:data]
        data = data.merge(options[:locals]) unless options[:locals].nil?

        full_path = Marfa.config.block_templates_path + '/' + options[:path]

        return render_content(full_path, data) unless cache_block

        # cache_key = Marfa.cache.create_key(kind, options[:path], tags)
        render_cached_content(options[:cache_key], full_path, data)
      end

      alias_method :render_component, :render_block
      # alias_method :render_static_component, :render_static_block
    end
  end
end