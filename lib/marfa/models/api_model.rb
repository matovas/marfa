require 'rest-client'
require 'json'

module Marfa
  # Extend Models
  module Models
    # Base model
    class APIModel
      # Base model error
      class ModelError < StandardError; end

      @aliases = {}

      # Get data
      # @param params [Hash] options hash
      # @example
      #   BaseModel.get_data({ path: 'category/list' })
      # @return [Hash] data from API
      def self.get_data(params)
        get_raw_data(params)
      end

      # Get data w/pagination headers x_count / x_pages
      # @param params [Hash] options hash
      # @example
      #   BaseModel.get_data({ path: 'category/list' })
      # @return [Hash] data from API
      def self.get_data_with_pagination(params)
        get_raw_data_with_pagination(params)
      end

      # "Raw" data getting
      # @param params [Hash] - options hash
      # @example
      #   self.get_raw_data({ path: 'category/list' })
      # @return [Hash]
      def self.get_raw_data(params)
        params[:query] = params[:query].delete_if { |k, v| v.nil? } unless params[:query].nil?
        result = {}
        path = params[:path]
        cache_key = "data_#{path}#{params[:query]}".scan(/[a-zA-Zа-яА-Я0-9]+/).join('_')
        cache_key = params[:cache_key] unless params[:cache_key].nil?

        begin
          if Marfa.cache.exist?(cache_key)
            result = JSON.parse(Marfa.cache.get(cache_key), symbolize_names: true)
          else
            response = RestClient.get("#{Marfa.config.api_server}#{path}", { params: params[:query], headers: {} })
            Marfa.cache.set(cache_key, response.body, params[:cache_time] || 7200)
            result = JSON.parse(response.body, symbolize_names: true)
          end
        rescue => exception
          if [:development, :test].include? Marfa.config.environment
            _log_exception(exception, path, params)
          end
        end

        result
      end

      # "Raw" data getting w/pagination headers x_count / x_pages
      # @param params [Hash] - options hash
      # @return [Hash]
      def self.get_raw_data_with_pagination(params)
        result = {}
        path = params[:path]
        cache_key = "data_with_pagination_#{path}#{params[:query]}".scan(/[a-zA-Zа-яА-Я0-9]+/).join('_')
        cache_key = params[:cache_key] unless params[:cache_key].nil?

        begin
          if Marfa.cache.exist?(cache_key)
            result = JSON.parse(Marfa.cache.get(cache_key), symbolize_names: true)
          else
            response = RestClient.get("#{Marfa.config.api_server}#{path}", { params: params[:query], headers: {} })
            result[:data] = JSON.parse(response.body, symbolize_names: true)
            result[:data_count] = response.headers[:x_count].to_i unless response.headers[:x_count].nil?
            result[:data_pages] = response.headers[:x_pages].to_i unless response.headers[:x_pages].nil?
            Marfa.cache.set(cache_key, result.to_json, params[:cache_time] || 7200)
          end
        rescue => exception
          if [:development, :test].include? Marfa.config.environment
            _log_exception(exception, path, params)
          end
        end

        result
      end

      # Log exceptions to console
      def self._log_exception(e, path, params)
        p '========== Exception while making request: =========='
        p "Path: #{Marfa.config.api_server}#{path}"
        p 'Params:'
        p params
        p "#{e.message} (#{e.class})"
        p '=================================================='
      end
    end
  end
end