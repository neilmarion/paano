require 'spec_helper'

describe User do
  it { should validate_presence_of :provider }
  it { should validate_presence_of :uid } 
  it { should have_many :questions }
  it { should have_many :answers }

  it "should give user's reputation when a question is voted on" do
    question = FactoryGirl.create(:question)    
    question.add_evaluation(:votes, 1, FactoryGirl.create(:user_facebook))
    question.user.karma.should eq question.reputation_for(:votes)
  end

  it "should give user's reputation when an answer is voted on" do
    answer = FactoryGirl.create(:answer)    
    answer.add_evaluation(:votes, 1, FactoryGirl.create(:user_facebook))
    answer.user.karma.should eq question.reputation_for(:votes)
  end
end
