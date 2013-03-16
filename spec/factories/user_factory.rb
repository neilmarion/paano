FactoryGirl.define do
  factory :user do
    
  end

  factory :user_twitter, :parent => :user do
    provider "twitter"
    sequence(:uid) { |n| "#{n}" }
    sequence(:name) { |n| "User_#{n}" }
  end
end
