# encoding: utf-8

require 'redis'
require 'yaml'

# Redis-cache wrapper
module Marfa
  # Redis-cache wrapper
  class Cache
    def initialize
      @config = YAML.load_file('./config/cache.yml')
      @redis = Redis.new(host: @config['host'], port: @config['port'], db: @config['db'])
    end

    # Write data to cache
    # @example
    #   $cache.set('key', 'value', 7200)
    def set(key, value, _time = @config['expiration_time'])
      return unless @config['enabled']
      @redis.set(key, value)
    end

    # Get data from cache
    # @param key [String] cache key
    # @example
    #   $cache.get('key')
    # @return [String] data from cache
    # @return [Nil]
    def get(key)
      @redis.get(key)
    end

    # Check that key exist in cache
    # @param key [String] ключ
    # @example
    #   $cache.exist?('key')
    # @return [Boolean]
    def exist?(key)
      return unless @config['enabled']
      @redis.exists(key)
    end

    # Delete data from cache
    # @param key [String] cache key
    # @example
    #   $cache.delete('key')
    def delete(key)
      @redis.del(key)
    end

    # Delete data from cache by pattern
    # @param pattern [String] pattern
    # @example
    #   $cache.delete_by_pattern('pattern')
    def delete_by_pattern(pattern)
      keys = @redis.keys("*#{pattern}*")
      @redis.del(*keys) unless keys.empty?
    end

    # Create key by params
    # @param kind [String] kind (block or page)
    # @param path [String] path
    # @param tags [Array] tag list
    # @example
    #   $cache.create_key('block', 'offer/list', ['tag1', 'tag2'])
    # @return [String] key
    def create_key(kind, path, tags)
      kind + '_' + path.tr('/', '_') + '__' + tags.join('_')
    end

    # Create key for json urls
    # @param path [String] path
    # @example
    #   $cache.create_json_key('/get_list.json')
    # @return [String] key
    def create_json_key(path)
      path.gsub(%r{[/.]}, '_')
    end
  end
end

