require 'spec_helper'

describe Answer do
  it { should belong_to :question }
  it_behaves_like "a post"

  it "has votes" do
    question = FactoryGirl.create(:question)
    answer = FactoryGirl.create(:answer, question: question)
    answer.votes.should eq 0
  end 

  it "inherits the tags of the parent on create" do
    question = FactoryGirl.create(:question)
    question.answers.create(content: "Answer")
    question.answers.first.tags.should eq question.tags
  end

  describe "vote_count reputation" do
    before(:each) do
      @post = FactoryGirl.create(:answer, question: FactoryGirl.create(:question))
      @rep = :answer_vote_count
    end

    it_behaves_like "it has vote_count reputation"
  end
end
