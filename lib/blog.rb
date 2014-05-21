module Blog
  extend ActiveSupport::Autoload

  autoload :Convertor

  def self.logger
    @logger ||= Logger.new(File.join(Rails.root, 'log', "blog_#{Rails.env}.log"))
  end
end
