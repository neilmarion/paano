require 'spec_helper'

describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it "should validate format of email" do
    FactoryGirl.create(:user)
  end
end
