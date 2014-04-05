require "ostruct"
class Blog::Config
  #cattr_reader :config

  def self.config
    @@config ||= setup
  end

  def self.setup(&block)
    @@config ||= OpenStruct.new
    @@config.post ||= OpenStruct.new table_name: :blog_posts
    @@config.comment ||= OpenStruct.new table_name: :blog_comments
    #if block_defined?
      block.call(@@config)
    #end
  end
end

