require 'spec_helper'

describe Users::OmniauthCallbacksController do
  describe 'fail' do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end

    describe 'invalid user' do
      it 'fails' do
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
        #User.any_instance.expects(:persisted?).returns false
        get :facebook
        response.should redirect_to root_path 
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
end
