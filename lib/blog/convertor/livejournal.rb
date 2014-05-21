module Blog
  module Convertor
    module Livejournal
      extend self
      def format?(text)
        false
      end
    end
  end
end

