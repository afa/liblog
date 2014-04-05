#coding: UTF-8
FactoryGirl.define do
 sequence :username do |n|
 "username_#{n}"
 end

 sequence :name do |n|
 "name_#{n}"
 end

 sequence :email do |n|
   "user_#{n}@afalone.it"
 end

 factory :user, class: 'User' do
  username
  name
  email
  password 'password'
  after(:create) do |user, ev|
    if user.password.blank?
      user.password = 'password'
      user.update_password
    end
  end
 end

 sequence :book_name do |n|
  "book #{n}"
 end
 factory(:book) do
  name { next(:book_name) }
  fbguid { "guid-#{rand(899)+100}-#{rand(89)+10}" }
 end

end
