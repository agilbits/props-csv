require File.expand_path("../../lib/key_group_factory.rb", __FILE__)

describe KeyGroupFactory do
  context "creating empty groups" do
    before do
      @to_IO = lambda { |path|  StringIO.new }
    end
    
    it "should create model for one file" do
      factory = KeyGroupFactory.new ['path/messages.properties'], @to_IO
      factory.groups.should == [KeyGroup.new('path/messages')]
    end

    it "should have no key for empty IO" do
      factory = KeyGroupFactory.new ['path/messages.properties'], @to_IO
      factory.groups[0].keys.should == []
    end
  
    it "should create two key groups for two files with different prefixes" do
      factory = KeyGroupFactory.new ['path/messages.properties', 'path/plugin.properties'], @to_IO
      factory.groups.should == [KeyGroup.new('path/messages'), KeyGroup.new('path/plugin')]
    end
  
    it "should create one key group for two files with same prefix" do
      factory = KeyGroupFactory.new ['path/messages.properties', 'path/messages_pt.properties'], @to_IO
      factory.groups.should == [KeyGroup.new('path/messages')]
    end
  end
  
  context "for groups with keys" do
    # TODO Add test to verify force_encoding is there
    it "should load group with single key" do
      @to_IO = lambda { |path| io = StringIO.new; io.puts 'test=valu\'e'; io.rewind; io }
      factory = KeyGroupFactory.new ['path/messages.properties'], @to_IO
      group = factory.groups[0]
      group.keys.should == ['test']
    end
    
    it "should not load comments" do
      @to_IO = lambda { |path| io = StringIO.new; io.puts '# nice property comment'; io.rewind; io }
      factory = KeyGroupFactory.new ['path/messages.properties'], @to_IO
      group = factory.groups[0]
      group.keys.should == []
    end
    
    it "should load group with several keys" do
      @to_IO = lambda { |path| io = StringIO.new; io.puts 'test=value'; io.puts 'another=key'; io.rewind; io }
      factory = KeyGroupFactory.new ['path/messages.properties'], @to_IO
      group = factory.groups[0]
      group.keys.should == ['test', 'another']
    end

    it "should trim keys" do
      @to_IO = lambda { |path| io = StringIO.new; io.puts ' test =value'; io.puts 'another  =key'; io.rewind; io }
      factory = KeyGroupFactory.new ['path/messages.properties'], @to_IO
      group = factory.groups[0]
      group.keys.should == ['test', 'another']
    end

    context "regarding translations" do
      it "default should be available for each key" do
        @to_IO = lambda { |path| io = StringIO.new; io.puts 'test= value '; io.puts 'another=  key    '; io.rewind; io }
        factory = KeyGroupFactory.new ['path/messages.properties'], @to_IO
        group = factory.groups[0]
        group.translation_for('test', '').should == 'value'
        group.translation_for('another', '').should == 'key'
      end
      
      it "should load all translations" do
        @to_IO = lambda do |path|
          io = StringIO.new;
          if /pt_BR/.match path
            io.puts 'test= valor '; 
          else
            io.puts 'test= value '; 
          end
          io.rewind; io
        end
        factory = KeyGroupFactory.new ['path/messages.properties', 'path/messages_pt_BR.properties'], @to_IO
        group = factory.groups[0]
        group.translation_for('test', '').should == 'value'
        group.translation_for('test', 'pt_BR').should == 'valor'
      end
    end
  end
end
