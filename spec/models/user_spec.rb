require 'spec_helper'

describe User do
  it { should validate_presence_of :provider }
  it { should validate_presence_of :uid } 
  it { should have_many :questions }
  it { should have_many :answers }

  it "should give user's reputation when a question is voted on" do
    question = FactoryGirl.create(:question)    
    question.add_evaluation(:question_votes, 1, FactoryGirl.create(:user_facebook))
    question.user.karma.should eq question.reputation_for(:question_votes)
  end

  it "should give user's reputation when an answer is voted on" do
    question = FactoryGirl.create(:question)
    answer = FactoryGirl.create(:answer, question: question)    
    answer.add_evaluation(:answer_votes, 1, FactoryGirl.create(:user_facebook))
    answer.user.karma.should eq answer.reputation_for(:answer_votes)
  end
end
