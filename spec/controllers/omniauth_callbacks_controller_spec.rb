require 'spec_helper'

describe Users::OmniauthCallbacksController do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'fail' do
    describe 'invalid user' do
      it 'fails' do
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
        User.any_instance.should_receive(:persisted?).at_least(:once) { false }
        get :facebook
        response.should redirect_to new_user_session_path 
      end
    end

    describe 'invalid provider' do
      it "fails" do
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:bad_provider]
        get :facebook
        response.should_not be_success
      end
    end
  end

  describe 'success' do
    it 'logs in through a facebook account' do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
      get :facebook
      response.should redirect_to root_path
    end

    it 'logs in and redirects to previous route' do
      pending
    end
  end
end
