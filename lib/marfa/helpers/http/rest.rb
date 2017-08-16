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
          if Marfa.config.logging_level > 0
            $logger.info("REST GET url     = #{url}")
            $logger.info("REST GET headers = #{headers}")
          end

          if block.nil?
            response = RestClient.get(url, headers)

            if response.code == 200
              $logger.info("REST GET code    = #{response.code}") if Marfa.config.logging_level > 0
              $logger.info("REST DEL body    = #{response.body}") if Marfa.config.logging_level > 1
            else
              if Marfa.config.logging_level > 0
                $logger.error("REST GET code    = #{response.code}")
                $logger.error("REST GET body    = #{response.body}")
              end
            end

            return response
          else
            RestClient.get(url, headers) do |response|
              if response.code == 200
                $logger.info("REST GET code    = #{response.code}") if Marfa.config.logging_level > 0
                $logger.info("REST GET body    = #{response.body}") if Marfa.config.logging_level > 1
              else
                if Marfa.config.logging_level > 0
                  $logger.error("REST GET code    = #{response.code}")
                  $logger.error("REST GET body    = #{response.body}")
                end
              end

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
          if Marfa.config.logging_level > 0
            $logger.info("REST HEA url     = #{url}")
            $logger.info("REST HEA headers = #{headers}")
          end

          if block.nil?
            response = RestClient.head(url, headers)

            if response.code == 200
              $logger.info("REST HEA code    = #{response.code}") if Marfa.config.logging_level > 0
              $logger.info("REST HEA body    = #{response.body}") if Marfa.config.logging_level > 1
            else
              if Marfa.config.logging_level > 0
                $logger.error("REST HEA code    = #{response.code}")
                $logger.error("REST HEA body    = #{response.body}")
              end
            end

            return response
          else
            RestClient.head(url, headers) do |response|
              if response.code == 200
                $logger.info("REST HEA code    = #{response.code}") if Marfa.config.logging_level > 0
                $logger.info("REST HEA body    = #{response.body}") if Marfa.config.logging_level > 1
              else
                if Marfa.config.logging_level > 0
                  $logger.error("REST HEA code    = #{response.code}")
                  $logger.error("REST HEA body    = #{response.body}")
                end
              end

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
          if Marfa.config.logging_level > 0
            $logger.info("REST POS url     = #{url}")
            $logger.info("REST POS headers = #{headers}")
            $logger.info("REST POS payload = #{payload}")
          end

          if block.nil?
            response = RestClient.post(url, payload, headers)
            if response.code == 200
              $logger.info("REST POS code    = #{response.code}") if Marfa.config.logging_level > 0
              $logger.info("REST POS body    = #{response.body}") if Marfa.config.logging_level > 1
            else
              if Marfa.config.logging_level > 0
                $logger.error("REST POS code    = #{response.code}")
                $logger.error("REST POS body    = #{response.body}")
              end
            end

            return response
          else
            RestClient::Request.execute(
              method: :post,
              url: url,
              payload: payload,
              headers: headers
            ) do |response|
              if response.code == 200
                $logger.info("REST POS code    = #{response.code}") if Marfa.config.logging_level > 0
                $logger.info("REST POS body    = #{response.body}") if Marfa.config.logging_level > 1
              else
                if Marfa.config.logging_level > 0
                  $logger.error("REST POS code    = #{response.code}")
                  $logger.error("REST POS body    = #{response.body}")
                end
              end


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
          if Marfa.config.logging_level > 0
            $logger.info("REST PUT url     = #{url}")
            $logger.info("REST PUT headers = #{headers}")
            $logger.info("REST PUT payload = #{payload}")
          end

          if block.nil?
            response = RestClient.put(url, payload, headers)
            if response.code == 200
              $logger.info("REST PUT code    = #{response.code}") if Marfa.config.logging_level > 0
              $logger.info("REST PUT body    = #{response.body}") if Marfa.config.logging_level > 1
            else
              if Marfa.config.logging_level > 0
                $logger.error("REST PUT code    = #{response.code}")
                $logger.error("REST PUT body    = #{response.body}")
              end
            end

            return response
          else
            RestClient::Request.execute(
              method: :put,
              url: url,
              payload: payload,
              headers: headers
            ) do |response|
              if response.code == 200
                $logger.info("REST PUT code    = #{response.code}") if Marfa.config.logging_level > 0
                $logger.info("REST PUT body    = #{response.body}") if Marfa.config.logging_level > 1
              else
                if Marfa.config.logging_level > 0
                  $logger.error("REST PUT code    = #{response.code}")
                  $logger.error("REST PUT body    = #{response.body}")
                end
              end

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
          if Marfa.config.logging_level > 0
            $logger.info("REST DEL url     = #{url}")
            $logger.info("REST DEL headers = #{headers}")
            $logger.info("REST DEL payload = #{payload}")
          end

          if block.nil?
            response = RestClient.delete(url, headers)
            if response.code == 200
              $logger.info("REST DEL code    = #{response.code}") if Marfa.config.logging_level > 0
              $logger.info("REST DEL body    = #{response.body}") if Marfa.config.logging_level > 1
            else
              if Marfa.config.logging_level > 0
                $logger.error("REST DEL code    = #{response.code}")
                $logger.error("REST DEL body    = #{response.body}")
              end
            end


            return response
          else
            RestClient::Request.execute(
                method: :delete,
                url: url,
                payload: payload,
                headers: headers
            ) do |response|
              if response.code == 200
                $logger.info("REST DEL code    = #{response.code}") if Marfa.config.logging_level > 0
                $logger.info("REST DEL body    = #{response.body}") if Marfa.config.logging_level > 1
              else
                if Marfa.config.logging_level > 0
                  $logger.error("REST DEL code    = #{response.code}")
                  $logger.error("REST DEL body    = #{response.body}")
                end
              end

              block.call(response)
            end
          end
        end
      end
    end
  end
end