#require "faker"
#Sham.login {Faker::Lorem.words(1)}
#Sham.name {Faker::Lorem.words(5)}
Factory.sequence(:user_login) do |n|
 "username_#{n}"
end
Factory.define :user do |u|
 u.username {Factory.next(:user_login)}
end

Factory.sequence :book_name do |n|
 "book #{n}"
end
Factory.define(:book) do | b |
 b.name { Factory.next(:book_name) }
 b.fbguid { "guid-#{rand(899)+100}-#{rand(89)+10}" }
end
