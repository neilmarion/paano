FactoryGirl.define do
  factory :question do
    sequence(:title) { |n| "Question Title #{n}" }
    sequence(:content) { |n| "Question Content #{n}" }
    sequence(:tag_list) { |n| "tag#{n}" }

    factory :question_with_an_answer do
      answers { Array.new(1) { FactoryGirl.build(:answer) } }
    end
  end
end
