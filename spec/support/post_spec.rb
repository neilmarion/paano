shared_examples "a post" do
  it { should belong_to :user }
  it { should validate_presence_of(:content)
    .with_message(I18n.t('activerecord.errors.models.post.attributes.content.blank')) }
end
