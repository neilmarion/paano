# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

file = File.read(
  File.expand_path(File.join(File.dirname(__FILE__), "development_questions_data.json")))
questions = ActiveSupport::JSON.decode(file)

file = File.read(
  File.expand_path(File.join(File.dirname(__FILE__), "development_answers_data.json")))
answers = ActiveSupport::JSON.decode(file)

def create_user(uid)
  token = Devise.friendly_token[0,20]
  User.create(provider: "facebook", uid: uid, name: Faker::Name.name,
    email: Faker::Internet.email, password: token, password_confirmation: token)
end

for i in 1..20
  question = create_user(i).questions.create(title: questions[i-1]['title'], content: questions[i-1]['content'], tag_list: Faker::Name.first_name)
  create_user(i).answers.create(content: answers[i-1]['content'], tag_list: Faker::Name.first_name,
    question: question)
end


