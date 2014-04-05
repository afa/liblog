FactoryGirl.define do
  sequence :comment_title do |n|
    "title_#{n}"
  end
  factory :comment, class: 'Blog::Comment' do
    title {next :post_title}
    text "asdf aa ss qqweqcdac ksv"
    post
  end
end

