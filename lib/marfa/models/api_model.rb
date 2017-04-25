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
            p '========== Exception while making request: =========='
            p "Path: #{Marfa.config.api_server}#{path}"
            p 'Params:'
            p params
            p "#{exception.message} (#{exception.class})"
            p '=================================================='
          end
        end

        result
      end
    end
  end
end