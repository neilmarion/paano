FactoryGirl.define do
  factory :comment do
    sequence(:content) { |n| "Post Comment #{n}" }
    user { FactoryGirl.build(:user_facebook) }
  end 
end
