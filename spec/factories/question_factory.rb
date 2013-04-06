FactoryGirl.define do
  factory :question do
    sequence(:title) { |n| "Question Title #{n}" }
    sequence(:content) { |n| "Question Content #{n}" }

    factory :question_with_an_answer do
      after(:create) do |question|
        FactoryGirl.create(:answer, question: question)
      end
    end
  end
end
