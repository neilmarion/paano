class User < ActiveRecord::Base
  attr_accessible :name, :provider, :uid

  validates_presence_of :name
  validates_presence_of :provider
  validates_presence_of :uid




end
