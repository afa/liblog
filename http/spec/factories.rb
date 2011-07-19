FactoryGirl.define do
 sequence :username do |n|
 "username_#{n}"
 end
 factory :user do
  username
 end

 sequence :book_name do |n|
  "book #{n}"
 end
 factory(:book) do
  name { Factory.next(:book_name) }
  fbguid { "guid-#{rand(899)+100}-#{rand(89)+10}" }
 end
end
