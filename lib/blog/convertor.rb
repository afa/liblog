module Blog
  module Convertor
    extend ActiveSupport::Autoload
    extend self

    def detect(text)
      %w(Markdown Livejournal).map{|s| "Blog::Convertor::#{s}".constantize }.detect{|frmt| frmt.format?(text) }
    end
    autoload :Markdown
    autoload :Livejournal

    module Base
    end
  end
end
