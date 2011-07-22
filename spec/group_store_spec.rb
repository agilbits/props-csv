require File.expand_path("../spec_helper.rb", __FILE__)

describe PropsCSV::GroupStore do
  before do
    @store = PropsCSV::GroupStore.new
  end
  
  it "should be empty at start" do
    @store.groups.should == []
  end
  
  it "should return new group with given id if asked group with unstored id" do
    @store.group("messages").should == PropsCSV::KeyGroup.new("messages")
  end

  it "should return stored group if asked group with stored id" do
    group = @store.group("messages")
    @store.group("messages").should be_equal(group)
  end

  it "should store all groups with different ids" do
    @store.group("messages")
    @store.group("plugin")
    @store.groups.should == [PropsCSV::KeyGroup.new("messages"), PropsCSV::KeyGroup.new("plugin")]
  end
end