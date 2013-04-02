require 'spec_helper'

describe "On asking question" do
  it "goes to ask page when the #ask button is clicked" do
    visit root_path
    click_button "Ask"
    current_path.should eq new_question_path
  end

end
