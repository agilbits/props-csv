# encoding: UTF-8
require File.expand_path("../../lib/property_exporter.rb", __FILE__)

describe PropertyExporter do
  before do
    @io = StringIO.new
    @group = KeyGroup.new("messages")
    @exporter = PropertyExporter.new(@group, lambda{|path| @io})
  end
  
  it "should not export anything for empty group" do
    @exporter.export('')
    
    @io.rewind
    @io.gets.should be_nil
  end
  
  it "should export one key" do
    @group.add_translation("key", "", "value")
    
    @exporter.export('')
    
    @io.rewind
    @io.gets.should == "key=value\n"
    @io.gets.should be_nil
  end
  
  it "should export different key/value" do
    @group.add_translation("another", "", "test")
    
    @exporter.export('')
    
    @io.rewind
    @io.gets.should == "another=test\n"
    @io.gets.should be_nil
  end
  
  it "should export two keys" do
    @group.add_translation("key", "", "value")
    @group.add_translation("another", "", "test")
    
    @exporter.export('')
    
    @io.rewind
    @io.gets.should == "key=value\n"
    @io.gets.should == "another=test\n"
    @io.gets.should be_nil
  end
  
  it "should not export key that is not present in given language" do
    @group.add_translation("key", "", "value")
    @group.add_translation("another", "pt_BR", "test")
    
    @exporter.export('')
    
    @io.rewind
    @io.gets.should == "key=value\n"
    @io.gets.should be_nil
  end
  
  it "should export value with line breaks" do
    @group.add_translation("key", "", "value\nwith\nmany lines")
    
    @exporter.export('')
    
    @io.rewind
    @io.gets.should == "key=value\\n\\\n"
    @io.gets.should == "with\\n\\\n"
    @io.gets.should == "many lines\n"
    @io.gets.should be_nil
  end

  context "regarding encoding" do
    it "should export value to encoding ISO-8859-1" do
      @group.add_translation("key", "", "valué")

      @exporter = PropertyExporter.new(@group, lambda{|path| @io}, "ISO-8859-1")
      @exporter.export('')

      @io.rewind
      @io.gets.should == "key=valué\n".encode("ISO-8859-1")
      @io.gets.should be_nil
    end

    it "should export value to encoding MacRoman" do
      @group.add_translation("key", "", "valué")

      @exporter = PropertyExporter.new(@group, lambda{|path| @io}, "MacRoman")
      @exporter.export('')

      @io.rewind
      @io.gets.should == "key=valué\n".encode("MacRoman")
      @io.gets.should be_nil
    end

    it "should export value from encoding ISO-8859-1" do
      @group.add_translation("key", "", "valué".encode("ISO-8859-1"))

      @exporter = PropertyExporter.new(@group, lambda{|path| @io}, "UTF-8", "ISO-8859-1")
      @exporter.export('')

      @io.rewind
      @io.gets.should == "key=valué\n"
      @io.gets.should be_nil
    end
  end
  
  context "regarding path" do
    before do
      @calls = []
      @exporter = PropertyExporter.new(@group, lambda{|path| @calls << path; @io})
    end

    it "should export default language to right path" do
      @exporter.export('')

      @calls.should == ['./messages.properties']
    end
    
    it "should export language to right path" do
      @exporter.export('pt_BR')

      @calls.should == ['./messages_pt_BR.properties']
    end

    it "should export group to right path" do
      @group = KeyGroup.new("plugin")
      @exporter = PropertyExporter.new(@group, lambda{|path| @calls << path; @io})
      @exporter.export('pt_BR')

      @calls.should == ['./plugin_pt_BR.properties']
    end
  end
end
