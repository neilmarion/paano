shared_examples "a post" do
  it { should belong_to :user }
  it { should validate_presence_of :content }
  it { should have_many :taggings }
  it { should validate_presence_of(:taggings).
    with_message(I18n.t('activerecord.errors.models.post.attributes.taggings.blank')) }
end
