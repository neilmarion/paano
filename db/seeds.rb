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

file = File.read(
  File.expand_path(File.join(File.dirname(__FILE__), "development_tags_data.json")))
@tags = ActiveSupport::JSON.decode(file)

file = File.read(
  File.expand_path(File.join(File.dirname(__FILE__), "test_uids.json")))
@uids = ActiveSupport::JSON.decode(file)

def user(uid = @uids[rand(19)])
  token = Devise.friendly_token[0,20]
  User.create(provider: "facebook", uid: uid, name: Faker::Name.name,
    email: Faker::Internet.email, password: token, password_confirmation: token)
end

def random_tags
  size = @tags.size-1
  tag_list = [] 
  (rand(2)+1).times{
    tag_list << @tags[rand(size)]
  }
  tag_list.join(',')
end

def user_with_an_answer(question, answer = nil)
  user.answers.create(content: answer ? answer : Faker::Lorem.paragraph(rand(20)+1), tag_list: random_tags,
    post_id: question.id) 
end

for i in 1..20
  question = user.questions.create(title: questions[i-1]['title'], content: questions[i-1]['content'], 
    tag_list: random_tags)
  user_with_an_answer(question, answers[i-1]['content']) #english answer, not lorem
  rand(10).times{
    user_with_an_answer(question) #lorem answers, just for filling space
  }
end


