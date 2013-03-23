require 'spec_helper'

describe SessionsController do

  describe "GET 'create'" do
    before(:each) do
      @params = {"state" => "1234", "code" => "1234", "provider" => "facebook"}  
    end

    describe "success" do
      before(:each) do
        @controller.stubs(:env).returns("omniauth.auth" => 
          OmniAuth.config.mock_auth[:facebook])
      end

      it "signs up facebook users" do
        expect{  
          get :create, @params
        }.to change(User, :count).by 1
        session[:user_id].should eq User.first.id
      end

      it "signs in facebook user" do
        FactoryGirl.create(:user_facebook, uid: @params["code"])
        expect{
          get :create, @params
        }.to_not change(User, :count)
        session[:user_id].should eq User.first.id
      end
    end

    describe "fail" do
      before(:each) do
        @controller.stubs(:env).returns("omniauth.auth" => 
          OmniAuth.config.mock_auth[:facebook_fail])
      end

      it "does not sign up with an invalid auth returned by facebook" do
        pending
      end
    
      it "does not sign in with an invalid auth returned by facebook" do
        pending
      end
    end
  end

  describe "GET 'destroy'" do
    before(:each) do
      session[:user_id] = FactoryGirl.create(:user_facebook).id
    end

    it "destroys session" do
      get :destroy 
      session[:user_id].should be_nil
    end
  end

end
