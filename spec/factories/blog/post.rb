FactoryGirl.define do
  sequence :post_title do |n|
    "title_#{n}"
  end
  factory :post, class: 'Blog::Post' do
    title {next :post_title}
    text "asdf aa ss qqweqcdac ksv"
  end
end
