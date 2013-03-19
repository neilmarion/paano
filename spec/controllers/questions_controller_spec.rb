require 'spec_helper'

describe QuestionsController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "rspec cool mocks" do 
    before(:each) do 
      @person = double({name: "Neil"}) 
      User.stub(:find) { @person } 
      
    end 

    it "uses mocks" do
      @person2 = double({name: "Farhan"})
      User.find(1).name.should eq "Neil"
    end
  end


end
