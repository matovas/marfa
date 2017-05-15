module Rack
  class AppMapper
    NOT_FOUND = [404, { CONTENT_TYPE => 'text/plain' }, []].freeze

    attr_reader :apps

    def initialize(apps, app_map = {}, catch = [404, 405])
      @apps = []
      @has_app = {}
      @app_map = app_map

      apps.each { |app| add app }

      @catch = {}
      [*catch].each { |status| @catch[status] = true }
    end

    def call(env)
      res = NOT_FOUND

      @app_map.keys.each do |key|
        uri = env['PATH_INFO']
        next unless uri == key.to_s || uri.include?(key.to_s)

        app = @app_map[key]
        res = app.call(env)
        break
      end

      res
    end

    def add(app)
      @has_app[app] = true
      @apps << app
    end

    def include?(app)
      @has_app.include? app
    end

    alias << add
  end
end
