require 'spec_helper'

describe "Signing out" do
  it "successfully signs out" do
    visit root_path
    click_link I18n.t('general.sign_in_with_facebook') 
    page.should have_link I18n.t('.shared.navbar.user_links.user_dropdown.sign_out') 
    click_link I18n.t('.shared.navbar.user_links.user_dropdown.sign_out')
    page.should have_link I18n.t('general.sign_in_with_facebook') 
  end

end
