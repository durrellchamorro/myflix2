require 'spec_helper'

describe Photo do
  it { should belong_to(:video) }
  it { should validate_presence_of(:video) }
end
