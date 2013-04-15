FactoryGirl.define do
  factory :answer do
    sequence(:content) { |n| "Answer Content #{n}" }
    sequence(:tag_list) { |n| "tag#{n}" }
    
    user { FactoryGirl.build(:user_facebook) }
  end 
end
