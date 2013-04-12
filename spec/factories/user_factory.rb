FactoryGirl.define do
  factory :user
  factory :user_facebook, :parent => :user do
    provider "facebook"
    sequence(:uid) { |n| "#{n}" }
    sequence(:name) { |n| "User_#{n}" }
    sequence(:email) { |n| "user_#{n}@email.com"}
    password Devise.friendly_token[0,20]

    factory :user_with_a_question do
      questions { Array.new(1) { FactoryGirl.build(:question) } }
    end

    factory :user_with_an_answer do
      answers { Array.new(1) { FactoryGirl.build(:answer) } }
    end
  end
end
