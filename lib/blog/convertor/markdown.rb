module Blog
  module Convertor
    module Markdown
      extend self
      def format?(text)
        false
      end
    end
  end
end
