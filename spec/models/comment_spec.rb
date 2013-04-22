require 'spec_helper'

describe Comment do
  it { should belong_to :post }
  it_behaves_like "a post"
end
