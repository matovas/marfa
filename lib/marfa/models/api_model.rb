require 'rest-client'
require 'json'
require 'marfa/configuration'

module Marfa
  # Extend Models
  module Models
    # Base model
    class APIModel
      # Base model error
      class ModelError < StandardError; end

      include Marfa::Helpers::HTTP

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
        params[:query] = params[:query].delete_if { |_, v| v.nil? } unless params[:query].nil?
        path = params[:path]
        cache_key = params[:cache_key]
        # cache_key = "data_#{path}#{params[:query]}".scan(/[a-zA-Zа-яА-Я0-9]+/).join('_')
        # cache_key = params[:cache_key] unless params[:cache_key].nil?

        begin
          # don't need cache
          return _get_request_result(params) unless params[:cache_data]

          # cached data exists
          return JSON.parse(Marfa.cache.get(cache_key), symbolize_names: true) if Marfa.cache.exist?(cache_key)

          # get result and set to cache
          result = _get_request_result(params)
          Marfa.cache.set(cache_key, result.to_json, params[:cache_time] || Marfa.config.cache[:expiration_time])
          return result


          # if Marfa.cache.exist?(cache_key)
          #   result = JSON.parse(Marfa.cache.get(cache_key), symbolize_names: true)
          # else
          #   response = Rest.get("#{Marfa.config.api_server}#{path}", { params: params[:query], headers: {} })
          #   Marfa.cache.set(cache_key, response.body, params[:cache_time] || 7200)
          #   result = JSON.parse(response.body, symbolize_names: true)
          # end


        rescue => exception
          if [:development, :test].include? Marfa.config.environment
            _log_exception(exception, path, params)
          end
        end
      end

      # "Raw" data getting w/pagination headers x_count / x_pages
      # @param params [Hash] - options hash
      # @return [Hash]
      def self.get_raw_data_with_pagination(params)
        params[:query] = params[:query].delete_if { |_, v| v.nil? } unless params[:query].nil?
        path = params[:path]
        cache_key = params[:cache_key]
        # cache_key = "data_with_pagination_#{path}#{params[:query]}".scan(/[a-zA-Zа-яА-Я0-9]+/).join('_')
        # cache_key = params[:cache_key] unless params[:cache_key].nil?
        begin
          # don't need cache
          return _get_request_result_with_headers(params) unless params[:cache_data]

          # cached data exists
          return JSON.parse(Marfa.cache.get(cache_key), symbolize_names: true) if Marfa.cache.exist?(cache_key)

          result = _get_request_result_with_headers(params)
          Marfa.cache.set(cache_key, result.to_json, params[:cache_time] || Marfa.config.cache[:expiration_time])
          return result

          # if Marfa.cache.exist?(cache_key)
          #   result = JSON.parse(Marfa.cache.get(cache_key), symbolize_names: true)
          # else
          #   response = Rest.get("#{Marfa.config.api_server}#{path}", { params: params[:query], headers: {} })
          #   result[:data] = JSON.parse(response.body, symbolize_names: true)
          #   result[:data_count] = response.headers[:x_count].to_i unless response.headers[:x_count].nil?
          #   result[:data_pages] = response.headers[:x_pages].to_i unless response.headers[:x_pages].nil?
          #   Marfa.cache.set(cache_key, result.to_json, params[:cache_time] || 7200)
          # end
        rescue => exception
          if [:development, :test].include? Marfa.config.environment
            _log_exception(exception, path, params)
          end
        end
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

      def self._get_request_result(params)
        response = Rest.get("#{Marfa.config.api_server}#{params[:path]}", { params: params[:query], headers: {} })
        JSON.parse(response.body, symbolize_names: true)
      end

      def self._get_request_result_with_headers(params)
        result = {}
        response = Rest.get("#{Marfa.config.api_server}#{params[:path]}", { params: params[:query], headers: {} })
        result[:data] = JSON.parse(response.body, symbolize_names: true)
        result[:data_count] = response.headers[:x_count].to_i unless response.headers[:x_count].nil?
        result[:data_pages] = response.headers[:x_pages].to_i unless response.headers[:x_pages].nil?
        result
      end
    end
  end
end