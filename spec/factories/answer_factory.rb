FactoryGirl.define do
  factory :answer do
    sequence(:content) { |n| "Answer Content #{n}" }
    sequence(:tag_list) { |n| "tag#{n}" }
    

    factory :answer_with_a_user do
      user { FactoryGirl.build(:user_facebook) }
    end

    factory :answer_with_a_question_with_a_user do
      question { FactoryGirl.build(:user_with_a_question).questions.first }
      user { FactoryGirl.build(:user_facebook) }
    end
  end 
end
