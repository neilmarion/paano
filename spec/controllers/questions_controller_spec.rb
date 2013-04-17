require 'spec_helper'

describe QuestionsController do

  describe "index" do
    before(:each) do
      @question = FactoryGirl.create(:question)
      @question_with_an_answer = FactoryGirl.create(:question_with_an_answer)
    end

    it "returns all unanswered questions" do
      xhr :get, :index, {'filter' => 'unanswered'} 
      assigns(:questions).should eq [@question]
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
    let(:params) {{"question" => {"title" => "Question Title", "content" => "Question Content", "tag_list" => "tag_1, tag_2"}}}

    describe "success" do
      login_user 
    
      it "creates a new question" do
        expect { 
          xhr :post, :create, params 
        }.to change(Post, :count).by 1
        response.should redirect_to posts_path
      end
    end

    describe "fail" do
      describe "while user signed it" do
        login_user 

        it "does not create a question if it does not have a title" do
          params['question']['title'] = ""
          expect {
            xhr :post, :create, params 
          }.to_not change(Post, :count)
          response.should render_template("new")
        end

        it "does nto create a question if it does not have a content" do
          params['question']['content'] = ""
          expect {
            xhr :post, :create, params 
          }.to_not change(Post, :count)
          response.should render_template("new")
        end
        
        it "does not create a question if it does not have tags" do
          params['question']['tag_list'] = ""
          expect {
            xhr :post, :create, params
          }.to_not change(Post, :count)
          response.should render_template("new")
        end
      end

      describe "while user is not signed in" do
        it "does not create a question if a user is not signed in" do
          expect {
            xhr :post, :create, params 
          }.to_not change(Post, :count)
          response.status.should eq 401 #unauthorized access
        end
      end
    end
  end

  describe 'show' do
    it 'goes to show' do
      question = FactoryGirl.create(:question)
      xhr :get, :show, :id => question.id 
      response.should be_success
    end 
  end
end
