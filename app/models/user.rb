class User < ActiveRecord::Base

  devise :database_authenticatable, :omniauthable,
         :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation,
          :name, :provider, :uid

  validates_presence_of :provider
  validates_presence_of :uid

  has_many :evaluations, class_name: "RSEvaluation", as: :source
  has_many :questions
  has_many :answers

  has_reputation :karma,
      :source => [
          { :reputation => :questioning_skill },
          { :reputation => :answering_skill } ]

  has_reputation :questioning_skill,
      :source => [{ :reputation => :votes, :of => :questions }]

  has_reputation :answering_skill,
      :source => [{ :reputation => :votes, :of => :answers }]

  def self.from_omniauth(auth)
    where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.username = auth["info"]["nickname"]
      user.email = auth["info"]["email"]
      user.password = Devise.friendly_token[0,20]
    end
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def karma
    reputation_for(:karma).to_i
    #(reputation_for(:questioning_skill) + reputation_for(:answering_skill)).to_i
  end

end
