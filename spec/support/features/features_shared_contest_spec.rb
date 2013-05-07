shared_context "shared features stuff" do
  #before do
  #  @shared_var = :some_value
  #end
 
  def page_should_have_votes_count(votes) 
    page.should have_content I18n.t('posts.post.reputations.votes', votes: votes)
  end
 
  #let(:shared_let) { :some_value }
end
