require 'spec_helper'

describe Question do
  it { should validate_presence_of(:title)
    .with_message(I18n.t('activerecord.errors.models.post.attributes.title.blank')) }
  it { should have_many :answers }
  it_behaves_like "a post"
  it { should validate_presence_of(:tag_list)
    .with_message(I18n.t('activerecord.errors.models.post.attributes.tag_list.blank')) }

  it "has reputation" do
    question = FactoryGirl.create(:question)
    question.reputation.should eq 0
  end

  describe "vote_count reputation" do
    before(:each) do
      @post = FactoryGirl.create(:question)
      @rep = :question_vote_count
      @method = :vote_count
    end

    it_behaves_like "it has a reputation"
  end

  describe "reputation" do
    before(:each) do
      @post = FactoryGirl.create(:question)
      @rep = :question_reputation
      @method = :reputation
    end 

    it_behaves_like "it has a reputation"
  end

  describe "filters question" do
    before(:each) do
      @question = FactoryGirl.create(:question)
      @question_with_an_answer = FactoryGirl.create(:question_with_an_answer)
    end

    it "by no answers" do
      @question_with_an_answer
      questions = Question.find_questions_without_an_answer
      questions.should eq [@question]
    end
  end

  describe "Creating an answer" do
    before(:each) do
      @question = FactoryGirl.create(:question)
    end

    it "will increment answer_count" do
      expect{
        expect{
          @question.answers.create(content: "Answer content", tag_list: "tag_1, tag_2", user_id: FactoryGirl.create(:user_facebook).id)
          @question.reload
        }.to change(Answer, :count).by 1
       }.to change(@question, :answers_count).by 1

    end
  end
end
