require 'redis'
require 'yaml'

# Обертка для redis-кэша
module Marfa
  class Cache
    def initialize
      @config = YAML.load_file('./config/cache.yml')
      @redis = Redis.new(host: @config['host'], port: @config['port'], db: @config['db'])
    end

    # Записывает данные в кэш
    # @example
    #   $cache.set('key', 'value', 7200)
    def set(key, value, _time = @config['expiration_time'])
      return unless @config['enabled']
      @redis.set(key, value)
    end

    # Получает данные из кэша по ключу
    # @param key [String] ключ
    # @example
    #   $cache.get('key')
    # @return [String] данные из кэша / nil
    def get(key)
      @redis.get(key)
    end

    # Проверка на существование ключа в хранилище
    # @param key [String] ключ
    # @example
    #   $cache.exist?('key')
    # @return [Boolean] признак существования ключа
    def exist?(key)
      return unless @config['enabled']
      @redis.exists(key)
    end

    # Удаляет данные из хранилища по ключу
    # @param key [String] ключ
    # @example
    #   $cache.delete('key')
    def delete(key)
      @redis.del(key)
    end

    # Удаляет данные из хранилища по вхождению слова
    # @param pattern [String] маска
    # @example
    #   $cache.delete_by_pattern('pattern')
    def delete_by_pattern(pattern)
      keys = @redis.keys("*#{pattern}*")
      @redis.del(*keys) unless keys.empty?
    end

    # Создает ключ
    # @param kind [String] сущность (блок, страница)
    # @param path [String] путь
    # @param tags [Array] список тэгов
    # @example
    #   $cache.create_key('block', 'offer/list', ['tag1', 'tag2'])
    # @return [String] ключ
    def create_key(kind, path, tags)
      kind + '_' + path.tr('/', '_') + '__' + tags.join('_')
    end

    # Создает ключ для json данных
    # @param path [String] путь
    # @example
    #   $cache.create_json_key('/get_list.json')
    # @return [String] ключ
    def create_json_key(path)
      path.gsub(%r{[/.]}, '_')
    end
  end
end

