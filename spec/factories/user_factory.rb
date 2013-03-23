FactoryGirl.define do
  factory :user
    
  factory :user_facebook, :parent => :user do
    provider "facebook"
    sequence(:uid) { |n| "#{n}" }
    sequence(:name) { |n| "User_#{n}" }
  end

end
