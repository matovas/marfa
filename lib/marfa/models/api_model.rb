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
        result = {}
        path = params[:path]

        begin
          response = RestClient.get("#{Marfa.config.api_server}#{path}", { params: params[:query], headers: {} })
          result = JSON.parse(response.body, symbolize_names: true)
        rescue => exception
          if [:development, :test].include? Marfa.config.environment
            _log_exception(exception, path)
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

        begin
          response = RestClient.get("#{Marfa.config.api_server}#{path}", { params: params[:query], headers: {} })
          result[:data] = JSON.parse(response.body, symbolize_names: true)
          result[:data_count] = response.headers[:x_count].to_i unless response.headers[:x_count].nil?
          result[:data_pages] = response.headers[:x_pages].to_i unless response.headers[:x_pages].nil?
        rescue => exception
          if [:development, :test].include? Marfa.config.environment
            _log_exception(exception, path)
          end
        end

        result
      end

      # Log exceptions to console
      def self._log_exception(e, path)
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