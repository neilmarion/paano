require 'spec_helper'

describe User do
  it { should validate_presence_of :provider }
  it { should validate_presence_of :uid } 
  it { should have_many :questions }
  it { should have_many :answers }
  it { should have_many :posts }
  it { should have_many :comments }

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

  describe "sorting users" do
    before(:each) do
      @user1 = FactoryGirl.create(:user_facebook)
      @user2 = FactoryGirl.create(:user_facebook)
    end

    it "returns all users on descending order of karma reputation" do
      question1 = FactoryGirl.create(:question, user: @user2)
      question2 = FactoryGirl.create(:question, user: @user1)

      question1.add_evaluation(:question_reputation, 10, @user2)
      question2.add_evaluation(:question_reputation, 2, @user1)

      User.top.should eq [@user2, @user1]
    end

    it "returns all users on descending order of recency of creation" do
      User.recent.should eq [@user2, @user1]
    end
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

    describe "voted for" do
      it "is true" do
        @question.add_evaluation(:question_reputation, SCORING['down'], @user)
        @user.voted_for?(@question).should eq true 
      end

      it "is false" do
        @user.voted_for?(@answer).should eq false 
      end
    end
  end

  describe "is own post?" do
    before(:each) do
      @user = FactoryGirl.create(:user_facebook)
      @question = FactoryGirl.create(:question, user: @user)
      
    end

    it "is true" do
      @user.own_post?(@question).should eq true
    end

    it "is false" do
      @answer = FactoryGirl.create(:answer, question: @question)
      @user.own_post?(@answer).should eq false
    end
  end

  it "searches users by name" do
    user = FactoryGirl.create(:user_facebook, first_name: "Xxneilxx")
    User.search("neil").should eq [user]
  end
end
