require 'spec_helper'

describe QuestionsController do

  describe "index" do
    it "success" do
      xhr :get, :index
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

  describe "new" do
    describe "succeeds" do
      login_user      
      it "goes to questions/new" do
        xhr :get, :new  
        response.should be_success
        response.should render_template(:new)
      end
    end

    describe "fails" do 
      describe "when user not logged in" do
        it "unsucessfully goes to posts/new" do 
          xhr :get, :new
          response.status.should eq 401 #unauthorized access
        end
      end
    end
  end

  describe "create" do
    let(:params) {{"question" => {"title" => "Question Title", "content" => "Question Content", "tags" => {"0" => "question_tag"}}}}

    describe "success" do
      login_user 
    
      it "creates a new question" do
        xhr :post, :create, params 
        response.should redirect_to posts_path
      end
    end

    describe "fail" do
      describe "while user signed it" do
        login_user 

        it "does not create a question if it does not have a title" do
          params['question']['title'] = ""
          xhr :post, :create, params 
          request.should render_template("new")
        end

        it "does nto create a question if it does not have a content" do
          params['question']['content'] = ""
          xhr :post, :create, params 
          request.should render_template("new")
        end
        
        it "does not create a question if it does not have tags" do
          params['question']['tags'] = ""
          xhr :post, :create, params
          request.should render_template("new")
        end
      end

      describe "while user is not signed in" do
        it "does not create a question if a user is not signed in" do
          xhr :post, :create, {"question" => {"title" => "Question title", "content" => "Question Content"}}
          response.status.should eq 401 #unauthorized access
        end
      end
    end
  end

end
