require "faker"
Sham.login {Faker::Lorem.words(1)}
Sham.name {Faker::Lorem.words(5)}
Factory.define(:user) do |u|
 u.username {Sham.login}
end

Factory.define(:book) do | b |
 b.name { Sham.name }
 b.fbguid { "guid-#{rand(899)+100}-#{rand(89)+10}" }
end
