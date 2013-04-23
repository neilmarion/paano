class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    user = User.from_omniauth(request.env["omniauth.auth"])
    if user.persisted?
      flash.notice = "Signed in!"
      if request.env['HTTP_REFERER'] 
        sign_in user
        redirect_to request.env['HTTP_REFERER']
      else
        sign_in_and_redirect user
      end
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_session_path
    end
  end
  alias_method :facebook, :all
end
