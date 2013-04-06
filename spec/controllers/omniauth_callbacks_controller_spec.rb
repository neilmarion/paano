require 'spec_helper'

describe Users::OmniauthCallbacksController do

  describe 'invalid provider' do
    it "fails" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:bad_provider]
      get :facebook
      response.should_not be_success
    end
  end


end
