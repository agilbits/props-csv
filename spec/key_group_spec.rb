require File.expand_path("../../lib/key_group.rb", __FILE__)

describe KeyGroup do
  before do
    @group = KeyGroup.new('project/i18n/br/com/agilbits/messages')
  end
  
  it "should be created with path" do
    @group.id.should == 'project/i18n/br/com/agilbits/messages'
  end
  
  it "should remove language from path" do
    @group = KeyGroup.new('project/i18n/br/com/agilbits/messages_en')
    @group.id.should == 'project/i18n/br/com/agilbits/messages'
  end
  
  it "should equal other key group with same path" do
    other = KeyGroup.new('project/i18n/br/com/agilbits/messages')
    @group.should == other
    other.should == @group
  end
  
  it "should not equal other key group with different path" do
    other = KeyGroup.new('project/i18n/br/com/agilbits/plugin')
    @group.should_not == other
    other.should_not == @group
  end
  
  it "should equal other key group with same path but different language" do
    other = KeyGroup.new('project/i18n/br/com/agilbits/messages_en')
    @group.should == other
    other.should == @group
  end
  
  it "should have no keys at start" do
    @group.keys.should == []
  end
  
  it "should be able to add unexisting key" do
    @group.add_key 'key'
    @group.keys.should == ['key']
  end

  it "should ignore adding existing key" do
    @group.add_key 'key'
    @group.add_key 'key'
    @group.keys.should == ['key']
  end
  
  it "should add translation for existing key and language" do
    @group.add_key 'key'
    @group.add_translation('key', '', 'value')
    @group.translation_for('key', '').should == 'value'
  end
  
  it "should add key and translation for unexisting key" do
    @group.add_translation('key', '', 'value')
    @group.translation_for('key', '').should == 'value'
  end
  
  it "should have nil translation for unexisting key" do
    @group.translation_for('key', '').should be_nil
  end
  
  it "should have no translations if empty" do
    @group.languages.should == []
  end
  
  it "should have default translation if only has key" do
    @group.add_translation('key', '', 'value')
    @group.languages.should == ['']
  end

  it "should have all translation added" do
    @group.add_translation('key', '', 'value')
    @group.add_translation('key', 'pt_BR', 'value')
    @group.add_translation('key', 'de', 'value')
    @group.languages.should == ['', 'de', 'pt_BR']
  end
end