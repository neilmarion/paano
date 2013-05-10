require 'spec_helper'

describe User do
  it { should validate_presence_of :provider }
  it { should validate_presence_of :uid } 
  it { should have_many :questions }
  it { should have_many :answers }

  it "should give user's reputation when a question is voted on" do
    question = FactoryGirl.create(:question)    
    question.add_evaluation(:question_reputation, 1, FactoryGirl.create(:user_facebook))
    question.user.karma.should eq question.reputation_for(:question_reputation)
  end

  it "should give user's reputation when an answer is voted on" do
    question = FactoryGirl.create(:question)
    answer = FactoryGirl.create(:answer, question: question)    
    answer.add_evaluation(:answer_reputation, 1, FactoryGirl.create(:user_facebook))
    answer.user.karma.should eq answer.reputation_for(:answer_reputation)
  end

  describe "determining whether or not the user has voted for a post or not" do
    before(:each) do
      @user = FactoryGirl.create(:user_facebook)
      @question = FactoryGirl.create(:question)
      @answer = FactoryGirl.create(:answer, question: @question)    
    end

    describe "voted up for" do
      it "is true" do
        @answer.add_evaluation(:answer_reputation, SCORING['up'], @user)
        @user.voted_up_for?(@answer).should eq true
      end

      it "is false" do
        @user.voted_up_for?(@question).should eq false 
      end
    end

    describe "voted down for" do
      it "is true" do
        @question.add_evaluation(:question_reputation, SCORING['down'], @user)
        @user.voted_down_for?(@question).should eq true 
      end

      it "is false" do
        @user.voted_down_for?(@answer).should eq false 
      end
    end
  end
end
