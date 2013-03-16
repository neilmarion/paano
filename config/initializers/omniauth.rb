OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, TWITTER['key'], TWITTER['secret']
  provider :facebook, FACEBOOK['key'], FACEBOOK['secret'],
    :scope => 'email', :display => 'popup'
end

