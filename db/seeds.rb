# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

for i in 1..10
  token = Devise.friendly_token[0,20]
  user = User.create(provider: "facebook", uid: i, name: Faker::Name.name,
    email: Faker::Internet.email, password: token, password_confirmation: token)
  for i in 1..10
    user.questions.create(title: "#{Faker::Lorem.sentence(2)} to #{Faker::Lorem.sentence(1)}")
  end 
end
