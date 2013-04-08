require 'spec_helper'

describe "Searching" do
  before(:all) do
    load_test_posts
  end

  after(:all) do
    Post.destroy_all
  end

  before(:each) do
    visit root_path
  end

  describe "will be successful" do
    it "after the #search_button is clicked and the relevance of the value in the #search_input query is > 0%" do
      pending
      click_button "search_button"  
    end

  end 

end
