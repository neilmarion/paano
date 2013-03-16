require 'spec_helper'

describe Question do
  it { should belong_to(:user) }
  it { should_not allow_value("Random Question").for(:title) }
  it { should allow_value("From place to To Place").for(:title) }
end
