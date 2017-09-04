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
        def self.get(url, headers = {}, &block)
          _log_head('GET', url, headers)

          if block.nil?
            response = RestClient.get(url, headers)
            _log_body('GET', response.code, response.body)
            response
          else
            RestClient.get(url, headers) do |response|
              _log_body('GET', response.code, response.body)
              block.call(response)
            end
          end
        end

        # HEAD request
        # @param url [String] - url
        # @param headers [Hash] - headers hash
        # @example
        #   response = Rest.head(url)
        # @return response [RestClient::Response]
        def self.head(url, headers = {}, &block)
          _log_head('HEA', url, headers)

          if block.nil?
            response = RestClient.head(url, headers)
            _log_body('HEA', response.code, response.body)
            response
          else
            RestClient.head(url, headers) do |response|
              _log_body('HEA', response.code, response.body)
              block.call(response)
            end
          end
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
          _log_head('POS', url, headers, payload)

          if block.nil?
            response = RestClient.post(url, payload, headers)
            _log_body('POS', response.code, response.body)

            response
          else
            RestClient::Request.execute(
              method: :post,
              url: url,
              payload: payload,
              headers: headers
            ) do |response|
              _log_body('POS', response.code, response.body)
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
          _log_head('PUT', url, headers, payload)

          if block.nil?
            response = RestClient.put(url, payload, headers)
            _log_body('PUT', response.code, response.body)
            response
          else
            RestClient::Request.execute(
              method: :put,
              url: url,
              payload: payload,
              headers: headers
            ) do |response|
              _log_body('PUT', response.code, response.body)
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
        def self.delete(url, payload = {}, headers = {}, &block)
          _log_head('DEL', url, headers, payload)

          if block.nil?
            response = RestClient.delete(url, headers)
            _log_body('DEL', response.code, response.body)
            response
          else
            RestClient::Request.execute(
              method: :delete,
              url: url,
              payload: payload,
              headers: headers
            ) do |response|
              _log_body('DEL', response.code, response.body)
              block.call(response)
            end
          end
        end

        # logging head of request
        # @param type [String] - type of request
        # @param url [String] - url
        # @param headers [Hash] - headers hash
        # @param payload [Hash] - payload
        # @example
        #   _log_head(type, url, headers, payload)
        def self._log_head(type, url, headers, payload = nil)
          return if $logger.nil?
          $logger.info("REST #{type} url     = #{url}")
          $logger.info("REST #{type} headers = #{headers}")
          $logger.info("REST #{type} payload = #{payload}") unless payload.nil?
        end

        # logging body response of request
        # @param type [String] - type of request
        # @param code [String] - http code response
        # @param body [String] - response body
        # @example
        #   _log_body(type, response.code, response.body)
        def self._log_body(type, code, body)
          return if $logger.nil?
          if code == 200
            $logger.info("REST #{type} code    = #{code}")
            $logger.debug("REST #{type} body    = #{body}")
          else
            $logger.error("REST #{type} code    = #{code}")
            $logger.error("REST #{type} body    = #{body}")
          end
        end
      end
    end
  end
end
