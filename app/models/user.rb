class User < ActiveRecord::Base
  attr_accessible :name, :provider, :uid

  validates_presence_of :provider
  validates_presence_of :uid

  has_many :questions

  def self.from_omniauth(auth)
    where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["nickname"]
    end
  end




end
