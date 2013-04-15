FactoryGirl.define do
  factory :answer do
    sequence(:content) { |n| "Answer Content #{n}" }
    sequence(:tag_list) { |n| "tag#{n}" }

    # an answer must have a user and a question
    user { FactoryGirl.build(:user_facebook) }
    question { FactoryGirl.build(:question) }
  end 
end
