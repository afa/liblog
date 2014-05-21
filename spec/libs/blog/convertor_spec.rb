require 'spec_helper'
require 'blog'
describe 'Blog::Convertor' do
  context "#detect" do
    context 'when identifying' do
      it "should ask convertors for format" do
        %w(Markdown Livejournal).map{|s|"Blog::Convertor::#{s}".constantize}.each do |klass|
          klass.should_receive(:format?)
        end
        Blog::Convertor.detect('')
      end

      it "should identify format" do
        Blog::Convertor::Livejournal.should_receive(:format?).and_return(true)
        Blog::Convertor.detect('').should be_is_a Blog::Convertor::Livejournal
      end
    end
  end
end
