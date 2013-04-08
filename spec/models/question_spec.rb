require 'spec_helper'

describe Question do
  it { should validate_presence_of(:title)
    .with_message(I18n.t('activerecord.errors.models.post.attributes.title.blank')) }
  it { should have_many :answers }
  it_behaves_like "a post"
end
