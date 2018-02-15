require 'rest-client'
require 'json'
require 'marfa/configuration'
require 'marfa/exceptions'

module Marfa
  # Extend Models
  module Models
    # Base model
    class APIModel
      # Base model error
      class ModelError < StandardError; end

      include Marfa::Helpers::HTTP
      include Marfa::Exceptions

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

        begin
          # don't need cache
          return _get_request_result(params) if params[:cache_data].blank? || params[:cache_key].blank?

          # cached data exists
          return JSON.parse(Marfa.cache.get(cache_key), symbolize_names: true) if Marfa.cache.exist?(cache_key)

          # get result and set to cache
          result = _get_request_result(params)
          Marfa.cache.set(cache_key, result.to_json, params[:cache_time] || Marfa.config.cache[:expiration_time])

          return result

        rescue => exception
          if [:development, :test].include? Marfa.config.environment
            _log_exception(exception, path, params)
          end
        end

        {}
      end

      # "Raw" data getting w/pagination headers x_count / x_pages
      # @param params [Hash] - options hash
      # @return [Hash]
      def self.get_raw_data_with_pagination(params)
        params[:query] = params[:query].delete_if { |_, v| v.nil? } unless params[:query].nil?
        params[:query][:page] = 1 if params[:query][:page].blank?

        path = params[:path]
        cache_key = params[:cache_key]

        begin
          # don't need cache
          return _get_request_result_with_headers(params) if params[:cache_data].blank? || params[:cache_key].blank?

          # cached data exists
          return JSON.parse(Marfa.cache.get(cache_key), symbolize_names: true) if Marfa.cache.exist?(cache_key)

          result = _get_request_result_with_headers(params)
          Marfa.cache.set(cache_key, result.to_json, params[:cache_time] || Marfa.config.cache[:expiration_time])

          return result
        # Avoid range errors
        rescue RestClient::RangeNotSatisfiable
          params[:query][:page] = 1

          # try to get x_pages
          res = _get_request_result_with_headers(params)

          raise PagesRangeError.new('Page is out of range', res[:data_pages])
        rescue => exception
          if [:development, :test].include? Marfa.config.environment
            _log_exception(exception, path, params)
          end
        end

        {}
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

      # request result without headers
      # @return [Hash]
      def self._get_request_result(params)
        response = Rest.get("#{Marfa.config.api_server}#{params[:path]}", { params: params[:query], headers: {} })
        JSON.parse(response.body, symbolize_names: true)
      end

      # request result with headers
      # @return [Hash]
      def self._get_request_result_with_headers(params)
        result = {}

        thread = Thread.new do
          response = Rest.get("#{Marfa.config.api_server}#{params[:path]}", { params: params[:query], headers: {} })
          result[:data] = JSON.parse(response.body, symbolize_names: true)
          result[:data_count] = response.headers[:x_count].to_i unless response.headers[:x_count].nil?
          result[:data_pages] = response.headers[:x_pages].to_i unless response.headers[:x_pages].nil?
        end

        thread.join

        result
      end
    end
  end
end