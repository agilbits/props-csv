# encoding: UTF-8
require File.expand_path("../spec_helper.rb", __FILE__)

describe PropsCSV::PropertyParser do
  before do
    @parser = PropsCSV::PropertyParser.new("UTF-8", "UTF-8")
    @io = StringIO.new
  end
  
  it "should parse no property for empty IO" do
    @parser.parse(@io).should == {}
  end
  
  it "should not parse comments" do
    @io.puts '# nice property comment'
    @io.rewind
    
    @parser.parse(@io).should == {}
  end
  
  it "should parse one property for simple IO" do
    @io.puts 'test=value'
    @io.rewind

    @parser.parse(@io).should == {'test' => 'value'}
  end
  
  it "should parse several properties" do
    @io.puts 'test=value'
    @io.puts 'another=key'
    @io.rewind

    @parser.parse(@io).should == {'test' => 'value', 'another' => 'key'}
  end

  it "should trim keys" do
    @io.puts ' test =value'
    @io.puts 'another  =key'
    @io.rewind
    
    @parser.parse(@io).should == {'test' => 'value', 'another' => 'key'}
  end

  context "regarding encoding" do  
    it "should parse UTF-8 encoded values" do
      @io.puts "test=valué"
      @io.rewind
    
      @parser.parse(@io).should == {'test' => 'valué'}
    end
    
    it "should parse ISO-8859-1 encoded values" do
      @io.set_encoding("ISO-8859-1")
      @io.puts "test=valué".encode("ISO-8859-1")
      @io.rewind
      
      @parser = PropsCSV::PropertyParser.new("ISO-8859-1", "UTF-8")
      @parser.parse(@io).should == {'test' => 'valué'}
    end

    it "should parse multiline ISO-8859-1 encoded values" do
      @io.set_encoding("ISO-8859-1")
      @io.puts "test=valué\\".encode("ISO-8859-1")
      @io.puts "éulav".encode("ISO-8859-1")
      @io.rewind

      @parser = PropsCSV::PropertyParser.new("ISO-8859-1", "UTF-8")
      @parser.parse(@io).should == {'test' => 'valué éulav'}
    end
    
    it "should parse UTF-8 encoded values to ISO-8859-1 values" do
      @io.puts "test=valué"
      @io.rewind
    
      @parser = PropsCSV::PropertyParser.new("UTF-8", "ISO-8859-1")
      @parser.parse(@io).should == {'test' => 'valué'.encode("ISO-8859-1")}
    end
  end

  it "should parse value with multiple lines" do
    @io.puts "test=value\\"
    @io.puts "that\\"
    @io.puts "has\\"
    @io.puts "multi line contents"
    @io.rewind
    
    @parser.parse(@io).should == {'test' => 'value that has multi line contents'}
  end

  it "should parse slash within value if not last character of line" do
    @io.puts "test=multi \\line contents"
    @io.rewind
    
    @parser.parse(@io).should == {'test' => 'multi \\line contents'}
  end

  it "should parse value with line break" do
    @io.puts "test=multi \\nline contents"
    @io.rewind
    
    @parser.parse(@io).should == {'test' => "multi \nline contents"}
  end

  it "should parse last value ending with slash normally" do
    @io.puts "test=multi \\"
    @io.rewind
    
    @parser.parse(@io).should == {'test' => 'multi  '}
  end
end