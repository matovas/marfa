require 'marfa/configuration'

module Marfa
  # see Marfa
  module Helpers
    # HTTP helpers
    module HTTP
      # Helpers to use Rest requests
      class Rest
        # GET request
        # @param url [String] - url
        # @param headers [Hash] - headers hash
        # @example
        #   response = Rest.get(url, headers)
        # @return response [RestClient::Response]
        def self.get(url, headers = {})
          p "REST GET url = #{url}" if Marfa.config.logging_level > 0
          p "REST GET headers = #{headers}" if Marfa.config.logging_level > 0

          response = RestClient.get(url, headers)

          p "REST GET code = #{response.code}" if Marfa.config.logging_level > 0
          p response.body if Marfa.config.logging_level > 1

          response
        end

        # HEAD request
        # @param url [String] - url
        # @param headers [Hash] - headers hash
        # @example
        #   response = Rest.head(url)
        # @return response [RestClient::Response]
        def self.head(url, headers = {})
          p "REST HEAD url = #{url}" if Marfa.config.logging_level > 0
          p "REST HEAD headers = #{headers}" if Marfa.config.logging_level > 0

          response = RestClient.head(url, headers)

          p "REST HEAD code  = #{response.code}" if Marfa.config.logging_level > 0
          p response.body if Marfa.config.logging_level > 1

          response
        end

        # POST request
        # @param url [String] - url
        # @param payload [String] - request body
        # @param headers [Hash] - headers hash
        # @param block [Proc] - block code to run
        # @example
        #   response = Rest.post(url, payload)
        #   Rest.post(url, payload) do |response|
        # @return response [RestClient::Response]
        def self.post (url, payload, headers={}, &block)
          p "REST POST url = #{url}" if Marfa.config.logging_level > 0

          if Marfa.config.logging_level > 0
            p "REST POST headers= #{headers}"
            p "REST POST payload= #{payload}"
          end

          if block.nil?
            response = RestClient.post(url, payload, headers)
            p "REST POST code = #{response.code}" if Marfa.config.logging_level > 0
            p response.body if Marfa.config.logging_level > 1
            return response
          else
            RestClient::Request.execute(
              method: :post,
              url: url,
              payload: payload,
              headers: headers
            ) do |response|
              p "REST POST code  = #{response.code}" if Marfa.config.logging_level > 0
              p response.body if Marfa.config.logging_level > 1

              block.call(response)
            end
          end
        end

        # PUT request
        # @param url [String] - url
        # @param payload [String] - request body
        # @param headers [Hash] - headers hash
        # @param block [Proc] - block code to run
        # @example
        #   response = Rest.put(url, payload)
        #   Rest.put(url, payload) do |response|
        # @return response [RestClient::Response]
        def self.put(url, payload, headers = {}, &block)
          p "REST PUT url  = #{url}" if Marfa.config.logging_level > 0
          if Marfa.config.logging_level > 0
            p "REST PUT headers= #{headers}"
            p "REST PUT payload= #{payload}"
          end

          if block.nil?
            response = RestClient.put(url, payload, headers)
            p "REST PUT code   = #{response.code}" if Marfa.config.logging_level > 0
            p response.body if Marfa.config.logging_level > 1
            return response
          else
            RestClient::Request.execute(
              method: :put,
              url: url,
              payload: payload,
              headers: headers
            ) do |response|
              p "REST PUT code   = #{response.code}" if Marfa.config.logging_level > 0
              p response.body if Marfa.config.logging_level > 1

              block.call(response)
            end
          end
        end

        # DELETE request
        # @param url [String] - url
        # @param payload [String] - request body
        # @param headers [Hash] - headers hash
        # @param block [Proc] - block code to run
        # @example
        #   Rest.delete(url, payload, headers) do |response|
        # @return response [RestClient::Response]
        def self.delete(url, payload, headers = {}, &block)
          p "REST DELETE url    = #{url}" if Marfa.config.logging_level > 0
          if Marfa.config.logging_level > 0
            p "REST DELETE headers= #{headers}"
            p "REST DELETE payload= #{payload}"
          end

          RestClient::Request.execute(
            method: :delete,
            url: url,
            payload: payload,
            headers: headers
          ) do |response|
            p "REST DELETE code   = #{response.code}" if Marfa.config.logging_level > 0
            p response.body if Marfa.config.logging_level > 1

            block.call(response)
          end
        end
      end
    end
  end
end