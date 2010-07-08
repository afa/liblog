require 'machinist/active_record'

Sham.title {Faker::Lorem.sentence}
Sham.name {Faker::Lorem.sentence}
Sham.text {Faker::Lorem.paragraph}
Sham.annotation {Faker::Lorem.paragraph}
Sham.username {Faker::Lorem.name}
BlogPost.blueprint do
 title
 text
end

ToDo.blueprint do
 text
end
 
SiteConfig.blueprint do
 name {Faker::Lorem.name}
 value {Faker::Lorem.sentence}
end

Article.blueprint do
 name {Faker::Lorem.name}
end

Author.blueprint do
 name {Faker::Lorem.name}
end

BlogPost.blueprint do
 raw_header {Sham.title}
 raw_text {Sham.text}
 raw_type {'Simple'}
end

Stat.blueprint do
 for_day {Date.yesterday}
 counter {rand(999) + 1}
end

Book.blueprint do
 name
 fbguid {(rand(99999999)+1).to_s+'-'+(rand(9999)+1).to_s}
 lre_name {(rand(9999)+1).to_s}
 annotation
end
Lang.blueprint do
 name
end
User.blueprint do
 username
end
