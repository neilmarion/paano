FactoryGirl.define do
  factory :user
  factory :user_facebook, :parent => :user do
    provider "facebook"
    sequence(:uid) { |n| "#{n}" }
    sequence(:first_name) { |n| "User_first_name#{n}" }
    sequence(:last_name) { |n| "User_last_name#{n}" }
    email
    password Devise.friendly_token[0,20]
  end
end
