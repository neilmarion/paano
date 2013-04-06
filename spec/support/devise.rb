module ControllerMacros
  def login_user(factory = nil)
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryGirl.create(factory || :user_facebook)
      sign_in user
    end
  end
end
