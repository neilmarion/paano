require 'spec_helper'

describe QuestionsController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "POST 'create'" do    
 
    describe "success" do
      before(:each) do
        @params = { question: {title: "Las Pinas to Los Banos"} } 
        signin
      end

      it "creates a question" do
        expect{
          post :create, @params 
        }.to change(Post, :count).by 1
      end
    end

    describe "fail" do
      describe "user logged in" do
        before(:each) do
          signin
        end
      # correct question format is /(.*) to (.*)/
        it "does not create a question when question format is wrong" do
          expect {
            post :create, { question: {title: "Las Pinas"} }
          }.to_not change(Post, :count)
        end

        it "does not create a question if blank" do
          expect {
            post :create, { question: { title: "" } } 
          }.to_not change(Post, :count)
        end
      end
    end
 
  end

  describe "rspec cool mocks" do 
    before(:each) do 
      @person = double({name: "Neil"}) 
      User.stub(:find) { @person } 
      
    end 

    it "uses mocks" do
      @person2 = double({name: "Farhan"})
      User.find(1).name.should eq "Neil"
    end
  end

end
