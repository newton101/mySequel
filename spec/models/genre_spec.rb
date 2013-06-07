
require 'spec_helper'

describe Genre do
  fixtures :genres
  it { should have_and_belong_to_many :sequels }

  it "has fixtures inserted into the database" do
    Genre.count.should eq 7
  end
end
