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
end
