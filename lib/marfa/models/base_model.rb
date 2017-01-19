require 'rest-client'
require 'json'

# DEPRECATED SINCE 19/01/17
module Marfa
  # Extend Models
  module Models
    # Base model
    class BaseModel
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

      # Method that make request to delete data from API
      # @param model_id [Fixnum] id to delete
      # @example
      #   BaseModel.delete(19)
      # @return [Hash]
      def self.delete(model_id)
        model_name = name.downcase
        # data = {}

        # begin
        #   path = "#{Marfa.config.api_server}#{model_name}/#{model_id.to_s}"
        #   response = RestClient.delete(path, { params: {}, headers: {} })
        #   data = JSON.parse(response.body, symbolize_names: true)
        # rescue
        #   p '404 or ParserError'
        # end

        # Temporary code
        p "#{Marfa.config.api_server}#{model_name}/#{model_id}"
        p model_id

        data = { deleted: true }
        Marfa.cache.delete_by_pattern(model_name)
        data
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
        rescue
          p '404 or ParserError'
        end

        result
      end
    end
  end
end