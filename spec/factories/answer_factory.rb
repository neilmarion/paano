FactoryGirl.define do
  factory :answer do
    sequence(:content) { |n| "Answer Content #{n}" }
    sequence(:tag_list) { |n| "tag#{n}" }
  end 
end
