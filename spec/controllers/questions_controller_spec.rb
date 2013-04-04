require 'spec_helper'

describe QuestionsController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "returns all unanswered questions" do
      pending
    end

    it "returns all top questions" do
      pending
    end

    it "returns all hot questions" do
      pending
    end

    it "returns the current users' questions" do
      pending
    end

    it "returns all the questions in DESC order by date created" do
      pending
    end
  end

  describe 'GET new' do
    describe "success" do
      before(:each) do
        sign_in FactoryGirl.create(:user_facebook)
        #request.env["devise.mapping"] = Devise.mappings[:user]
      end

      it "goes to questions/new" do
        get :new  
        response.should be_success
        response.should render_template("new")
      end
    end

    describe "fail" do 
      describe "while user not signed in" do
        

        it "unsucessfully goes to posts/new" do 
          #stub_request(:get, new_question_path).to_return(:status => [500, "Internal Server Error"])
          get :new
          request.should redirect_to new_session_path
          #correct handling of exceptions
        end
      end
    end
  end

  describe 'POST create' do
    before(:each) do
      @params = {"question" => {"title" => "Question Title", "content" => "Question Content", "tags" => {"0" => "question_tag"}}}
    end

    describe "success" do
      before(:each) do
        sign_in FactoryGirl.create(:user_facebook)
      end
    
      it "creates a new question" do
        post :create, @params
      end
    end

    describe "fail" do
      describe "while user signed it" do
        before(:each) do
          sign_in FactoryGirl.create(:user_facebook)
        end

        it "does not create a question if it does not have a title" do
          @params['question']['title'] = ""
          post :create, @params
          request.should render_template("new")
        end

        it "does nto create a question if it does not have a content" do
          @params['question']['content'] = ""
          post :create, @params
          request.should render_template("new")
        end
        
        it "does not create a question if it does not have tags" do
          @params['question']['tags'] = ""
          post :create, @params
          request.should render_template("new")
        end
      end

      describe "while user is not signed in" do
        it "does not create a question if a user is not signed in" do
          post :create, {"question" => {"title" => "Question title", "content" => "Question Content"}}
          request.should redirect_to new_session_path
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
