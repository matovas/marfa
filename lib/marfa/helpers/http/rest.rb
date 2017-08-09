require 'marfa/configuration'

module Marfa
  # see Marfa
  module Helpers
    # HTTP helpers
    module HTTP
      # Helpers to use Rest requests
      class Rest

        # get request
        # @param url [String] - url
        # @param headers [Hash] - headers hash
        # @param json_parse [Hash] - parse json options
        # @param block [Hash] - other options
        def self.get (url, headers={}, &block)
          p "REST GET url    = #{url}" if Marfa.config.logging_level > 0
          p "REST GET headers= #{headers}" if Marfa.config.logging_level > 1

          response = RestClient.get(url, headers, &block)
          p "REST GET code   = #{response.code}" if Marfa.config.logging_level > 0

          p response.body if Marfa.config.logging_level > 1

          response
        end

        def self.post (url, payload, headers={}, &block)
          p "REST POS url    = #{url}" if Marfa.config.logging_level > 0
          if Marfa.config.logging_level > 1
            p "REST POS headers= #{headers}"
            p 'REST POS payload= '
            pp payload
          end

          response = RestClient.post(url, payload, headers, &block)
          p "REST POS code   = #{response.code}" if Marfa.config.logging_level > 0
          p response.body if Marfa.config.logging_level > 1

          response
        end

        def self.delete (url, payload, headers={}, &block)
          p "REST DEL url    = #{url}" if Marfa.config.logging_level > 0
          if Marfa.config.logging_level > 1
            p "REST DEL headers= #{headers}"
            p 'REST DEL payload= '
            pp payload
          end

          RestClient::Request.execute(
              :method => :delete,
              :url => url,
              :payload => payload,
              :headers => headers) do |response|
            p "REST DEL code   = #{response.code}" if Marfa.config.logging_level > 0

            p response.body if Marfa.config.logging_level > 1

            return response
          end
        end

      end
    end
  end
end