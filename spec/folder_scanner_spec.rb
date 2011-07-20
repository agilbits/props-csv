require File.expand_path("../../lib/folder_scanner.rb", __FILE__)

describe FolderScanner do
  it "should be created with a path" do
    scanner = FolderScanner.new('spec')
    scanner.property_files.should == []
  end
  
  context "existing folder" do
    before do
      @scanner = FolderScanner.new("resources")
    end
    
    it "should find a property file in the given folder" do
      @scanner.property_files.should == [
          'resources/br/com/agilbits/another.properties',
          'resources/br/com/agilbits/another_fr.properties',
          'resources/br/com/agilbits/another_pt_BR.properties',
          'resources/command.properties',
          'resources/messages.properties']
    end
    
    it "should ignore file with given name" do
      @scanner.property_files(:exclude => ['/messages']).should == [
          'resources/br/com/agilbits/another.properties',
          'resources/br/com/agilbits/another_fr.properties',
          'resources/br/com/agilbits/another_pt_BR.properties',
          'resources/command.properties']
    end
    
    it "should ignore files in a given directory" do
      @scanner.property_files(:exclude => ['/com/']).should == ['resources/command.properties', 'resources/messages.properties']
    end
    
    it "should ignore all given exclude patterns" do
      @scanner.property_files(:exclude => ['/com/', '/messages']).should == ['resources/command.properties']
    end
  end
end