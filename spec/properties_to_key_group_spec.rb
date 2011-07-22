# encoding: UTF-8
require File.expand_path("../spec_helper.rb", __FILE__)

describe PropsCSV::PropertiesToKeyGroup do
  context "creating empty groups" do
    before do
      @to_IO = lambda { |path|  StringIO.new }
    end
    
    it "should create model for one file" do
      factory = PropsCSV::PropertiesToKeyGroup.new ['path/messages.properties'], @to_IO, "UTF-8", "UTF-8"
      factory.groups.should == [PropsCSV::KeyGroup.new('path/messages')]
    end

    it "should have no key for empty IO" do
      factory = PropsCSV::PropertiesToKeyGroup.new ['path/messages.properties'], @to_IO, "UTF-8", "UTF-8"
      factory.groups[0].keys.should == []
    end
  
    it "should create two key groups for two files with different prefixes" do
      factory = PropsCSV::PropertiesToKeyGroup.new ['path/messages.properties', 'path/plugin.properties'], @to_IO, "UTF-8", "UTF-8"
      factory.groups.should == [PropsCSV::KeyGroup.new('path/messages'), PropsCSV::KeyGroup.new('path/plugin')]
    end
  
    it "should create one key group for two files with same prefix" do
      factory = PropsCSV::PropertiesToKeyGroup.new ['path/messages.properties', 'path/messages_pt.properties'], @to_IO, "UTF-8", "UTF-8"
      factory.groups.should == [PropsCSV::KeyGroup.new('path/messages')]
    end
  end
  
  context "for groups with keys" do
    before do
      @to_IO = lambda { |path|  StringIO.new }
      @mock_parser = mock(PropsCSV::PropertyParser)
      PropsCSV::PropertyParser.should_receive(:new).any_number_of_times.and_return(@mock_parser)
    end
    
    it "should load group with single key" do
      @mock_parser.should_receive(:parse).and_return({'test' => 'value'})

      factory = PropsCSV::PropertiesToKeyGroup.new ['path/messages.properties'], @to_IO, "UTF-8", "UTF-8"
      group = factory.groups[0]
      group.keys.should == ['test']
    end
    
    it "should load group with several keys" do
      @mock_parser.should_receive(:parse).and_return({'test' => 'value', 'another' => 'key'})

      factory = PropsCSV::PropertiesToKeyGroup.new ['path/messages.properties'], @to_IO, "UTF-8", "UTF-8"
      group = factory.groups[0]
      group.keys.should == ['test', 'another']
    end

    context "regarding translations" do
      it "default should be available for each key" do
        @mock_parser.should_receive(:parse).and_return({'test' => 'value', 'another' => 'key'})

        factory = PropsCSV::PropertiesToKeyGroup.new ['path/messages.properties'], @to_IO, "UTF-8", "UTF-8"
        group = factory.groups[0]
        group.translation_for('test', '').should == 'value'
        group.translation_for('another', '').should == 'key'
      end
      
      it "should load all translations" do
        @mock_parser.should_receive(:parse).and_return({'test' => 'value'}, {'test' => 'valor'})

        factory = PropsCSV::PropertiesToKeyGroup.new ['path/messages.properties', 'path/messages_pt_BR.properties'], @to_IO, "UTF-8", "UTF-8"
        group = factory.groups[0]
        group.translation_for('test', '').should == 'value'
        group.translation_for('test', 'pt_BR').should == 'valor'
      end
    end
  end
  
  it "should create parser with encodings" do
    @to_IO = lambda { |path|  StringIO.new }
    @mock_parser = mock(PropsCSV::PropertyParser)
    @mock_parser.should_receive(:parse).and_return({})
    PropsCSV::PropertyParser.should_receive(:new).with("ISO-8859-1", "MacRoman").and_return(@mock_parser)
    factory = PropsCSV::PropertiesToKeyGroup.new(['path/messages.properties'], @to_IO, "ISO-8859-1", "MacRoman")
  end
end
