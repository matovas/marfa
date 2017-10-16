require 'marfa/configuration'

module Marfa
  module Helpers
    module Controller
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
        full_path = 'pages/' + options[:path]
        return render_content(full_path, options[:data]) if options[:cache_page].blank? || options[:cache_key].blank?

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
      # @return [String]
      def query_to_tags(query)
        result = []
        if query.is_a? Hash
          query.each { |key, value| result << "#{key}-#{value}" }
        end
        result.join('_')
      end

      # Render block from cache, return html
      # @param options [Hash] - options hash
      # @example
      #   render_block({ path: 'index/index', tags: ['tag1', 'tag2'] })
      # @return [String] rendered block
      def render_block(options)
        cache_block = options[:cache_block]

        if cache_block
          content = get_cached_content(options[:cache_key])
          return content unless content.nil?
        end

        model_name = options[:model]
        return unless Object.const_defined?(model_name)

        model = Object.const_get(model_name)
        return unless model.respond_to? options[:method].to_sym

        data = model.send(options[:method].to_sym, options[:params])
        data = data.merge(options[:locals]) unless options[:locals].nil?

        full_path = Marfa.config.block_templates_path + '/' + options[:path]

        return render_content(full_path, data) unless cache_block

        render_cached_content(options[:cache_key], full_path, data)
      end

      # Render block from cache, return html without class eval
      # @param options [Hash] - params
      # @return [String] rendered block
      def render_static_block(options)
        return get_cached_content(options[:cache_key]) unless options[:cache_block].blank?
        full_path = "#{Marfa.config.block_templates_path}/#{options[:path]}"
        render_cached_content(options[:cache_key], full_path, options[:data])
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
        cache_block = options[:cache_block]

        # tags += query_to_tags(options[:query])
        if cache_block
          content = get_cached_content(options[:cache_key])
          return content unless content.nil?
        end

        data = options[:data]
        data = data.merge(options[:locals]) unless options[:locals].nil?

        full_path = Marfa.config.block_templates_path + '/' + options[:path]

        return render_content(full_path, data) unless cache_block

        render_cached_content(options[:cache_key], full_path, data)
      end

      alias_method :render_component, :render_block
      alias_method :render_static_component, :render_static_block
    end
  end
end