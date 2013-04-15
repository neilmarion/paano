require 'spec_helper'

describe Question do
  it { should validate_presence_of(:title)
    .with_message(I18n.t('activerecord.errors.models.post.attributes.title.blank')) }
  it { should have_many :answers }
  it_behaves_like "a post"

  describe "filters question" do
    before(:each) do
      @question = FactoryGirl.create(:user_with_a_question).questions.first
      @question_with_an_answer = FactoryGirl.create(:user_with_a_question_with_an_answer).questions.first
    end

    it "by no answers" do
      questions = Question.find_questions_without_an_answer
      questions.should eq [@question]
    end
  end

  describe "Creating an answer" do
    before(:each) do
      @question = FactoryGirl.create(:user_with_a_question).questions.first
    end

    it "will increment answer_count" do
      expect{
        @question.answers.create()
       }.to change(@question.answers_count).by 1
    end
  end
end
