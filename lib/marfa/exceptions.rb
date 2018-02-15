# Extending Marfa
module Marfa
  # Marfa Exceptions
  module Exceptions
    # Pages range error
    class PagesRangeError < StandardError
      attr_reader :redirect_page_to

      def initialize(msg = 'Page is out of range', redirect_page_to = 1)
        @redirect_page_to = redirect_page_to
        super(msg)
      end
    end
  end
end
