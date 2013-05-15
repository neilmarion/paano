require 'spec_helper'

describe QuestionsController do
  include_context "common controller stuff"

  describe "index" do
    before(:each) do
      @question = FactoryGirl.create(:question)
      @question_with_an_answer = FactoryGirl.create(:question_with_an_answer)
    end

    it "returns all unanswered questions" do
      xhr :get, :unanswered
      assigns(:questions).should eq [@question]
    end

    it "returns all hot questions" do
      pending
    end

    describe "returns the current users' questions" do
      it "fails because there's no user signed in" do
        xhr :get, :mine
        should_be_unauthorized_access
      end

      it "succeeds because there's a user signed in" do
        @user = sign_in_user
        #refactor the above block

        question = FactoryGirl.create(:question, user: @user)
        FactoryGirl.create(:question) # noise question
        # @question created above is the noise question
        xhr :get, :mine
        assigns(:questions).should eq [question]
      end
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
          should_be_unauthorized_access
        end
      end
    end
  end

  describe "create" do
    let(:params) {{"question" => {"title" => "Question Title", "content" => "Question Content", "tag_list" => "tag1, tag2", "answers_attributes"=>{"0"=>{"content"=>""}}}}}

    describe "success" do
      login_user 

      it "creates a new question and the first answer to that question if the user filled in an answer to the question" do
        params["question"]["answers_attributes"]["0"]["content"] = "My Answer"

        expect {
          expect {
            xhr :post, :create, params
          }.to change(Question, :count).by 1
        }.to change(Answer, :count).by 1
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
          should_be_unauthorized_access
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

  describe "update" do
    before(:each) do
      @post = FactoryGirl.create(:question)
      @post_key = :question
    end

    
    describe "a user answered the question" do
      before(:each) do
        @post_of_post_attributes_key = :answers_attributes
      end
    
      it_behaves_like "a user posted on a post"
    end

    describe "a user commented" do
      before(:each) do
        @post_of_post_attributes_key = :comments_attributes
      end
  
      it_behaves_like "a user posted on a post"
    end   
  end

  describe 'answer' do # ajax validator whehter a user can able to answer or not (logged in or not)
    it 'fails if user is not logged in' do
      xhr :get, :answer, {format: :json}
      should_be_unauthorized_access
    end

    it 'succeeds if user is logged in' do
      user = FactoryGirl.create(:user_facebook)
      sign_in user    
      xhr :get, :answer, {format: :json}
      response.should be_success
    end
  end

  describe 'voting' do
    before(:each) do
      @user = sign_in_user
      @user2 = FactoryGirl.create(:user_facebook)
      @post = FactoryGirl.create(:question, user: @user2) 
      @post2 = FactoryGirl.create(:question, user: @user)
      @params = {id: @post.id}
      @params2 = [id: @post2.id]
      @model_class = Question
      @rep_name = :question_reputation 
    end 
  
    it_behaves_like "a user voted on a post"
  end

  describe 'destroy' do
    before(:each) do
      @question = FactoryGirl.create(:question) 
      @answer = FactoryGirl.create(:answer, question: @question)
      @comment = FactoryGirl.create(:comment, post: @answer)
    end 

    describe "user signed in" do
      before(:each) do
        sign_in_user
      end
  
      it "will destroy it and the associated records" do
        expect{
          expect{
            expect{
              expect{
                expect{
                  expect{
                    xhr :post, :destroy, {id: @question.id}  
                  }.to change(Question, :count).by -1
                }.to change(Answer, :count).by -1
              }.to change(Comment, :count).by -1
            }.to_not change(Question.with_deleted, :count)
          }.to_not change(Answer.with_deleted, :count)
        }.to_not change(Comment.with_deleted, :count)
      end 

      it "will fail to destroy the record" do
        Question.any_instance.should_receive(:destroy).and_return false
        expect{
          expect{
            expect{
              xhr :post, :destroy, {id: @question.id}  
            }.to_not change(Question, :count)
          }.to_not change(Answer, :count)
        }.to_not change(Comment, :count)
      end 
    end

    describe "user not signed in" do
      before(:each) do
        @post = @question
        @model_class = @post.class
      end
  
      it_behaves_like "a user not signed in attempted to delete a post"
    end
  end
end
