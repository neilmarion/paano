require 'spec_helper'

describe "Filtering top questions i.e. clicking the 'Top' link at home" do
  before(:each) do
    title = "title"
    content = "title"
    tag_list = "tag"
    @post_1 = FactoryGirl.create(:question, title: title, content: content, tag_list: tag_list)
    @post_2 = FactoryGirl.create(:question, title: title, content: content, tag_list: tag_list)
    @post_2.add_evaluation(:votes, 10, FactoryGirl.create(:user_facebook))
    visit root_path
    current_path.should eq root_path 
  end

  it "filters questions without an answer" do
    page.body.should =~ /#{@post_2.title}.*#{@post_1.title}/ 
  end
end
