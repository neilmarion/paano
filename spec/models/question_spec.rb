require 'spec_helper'

describe Question do
  it { should validate_presence_of :title}
  it { should have_many :answers }
  it_behaves_like "a post"
end
