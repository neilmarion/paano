FactoryGirl.define do
  factory :question do
    sequence(:title) { |n| "Question Title #{n}" }
    sequence(:content) { |n| "Question Content #{n}" }
  end
end
