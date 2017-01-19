# Extend Marfa
module Marfa
  # Extend Models
  module Models
    # Base model
    class DBModel
      # Base model error
      class ModelError < StandardError; end

      # @return [Hash] data from DB
      def self.get_data(params)
        {}
      end
    end
  end
end