require 'spec_helper'

describe Answer do
  it { should belong_to :question }
  it_behaves_like "a post"
end
