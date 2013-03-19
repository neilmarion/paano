require 'spec_helper'

describe SessionsController do

  describe "GET 'create'" do
    before(:each) do
     # stub_request(:get, "https://graph.facebook.com/oath/authorize?").to_return(:status => 500, :body =>     "{hello}", :headers => {})
      @controller.stubs(:env).returns("omniauth.auth" => Hashie::Mash.new(uid: '555', provider: 'facebook', info: { name: 'facebookuser' }))
    end

    it "signs up facebook users" do
      expect{  
        get :create, {"state" => "a", "code" => "a", "provider" => "facebook"}  
      }.to change(User, :count).by 1
    end
  end

  describe "GET 'destroy'" do
    pending
  end

end
