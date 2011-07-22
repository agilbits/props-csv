# encoding: UTF-8
require File.expand_path("../spec_helper.rb", __FILE__)

describe PropsCSV::CSVToKeyGroup do
  it "should create no key groups for empty csv" do
    converter = PropsCSV::CSVToKeyGroup.new([])
    converter.groups.should == []
  end
  
  it "should create no key groups for csv with only headers" do
    converter = PropsCSV::CSVToKeyGroup.new([["Arquivo", "Chave", ""]])
    converter.groups.should == []
  end

  it "should create one key group for csv with headers and one property" do
    converter = PropsCSV::CSVToKeyGroup.new([["Arquivo", "Chave", ""], ["messages", "key", "value"]])
    converter.groups.should == [PropsCSV::KeyGroup.new("messages")]
  end
  
  it "should create one key group with one translation for csv with headers and one language" do
    converter = PropsCSV::CSVToKeyGroup.new([["Arquivo", "Chave", ""], ["messages", "key", "value"]])
    
    converter.groups[0].translation_for("key", "").should == "value"
  end

  it "should create one key group with one translation for csv with headers and different language" do
    converter = PropsCSV::CSVToKeyGroup.new([["Arquivo", "Chave", "pt_BR"], ["messages", "key", "valor"]])
    
    converter.groups[0].translation_for("key", "pt_BR").should == "valor"
  end

  it "should create one key group with two translations for csv with headers and different languages" do
    converter = PropsCSV::CSVToKeyGroup.new([["Arquivo", "Chave", "", "pt_BR"], ["messages", "key", "value", "valor"]])
    
    group = converter.groups[0]
    group.translation_for("key", "").should == "value"
    group.translation_for("key", "pt_BR").should == "valor"
  end

  it "should create one key group with two keys for csv with headers and two rows" do
    converter = PropsCSV::CSVToKeyGroup.new([["Arquivo", "Chave", ""], ["messages", "key", "value"], ["messages", "another", "test"]])
    
    converter.groups.size.should == 1
    
    group = converter.groups[0]
    group.translation_for("key", "").should == "value"
    group.translation_for("another", "").should == "test"
  end

  it "should create two key groups for csv with headers and two rows for different files" do
    converter = PropsCSV::CSVToKeyGroup.new([["Arquivo", "Chave", ""], ["messages", "key", "value"], ["plugin", "another", "test"]])
    
    converter.groups.should == [PropsCSV::KeyGroup.new("messages"), PropsCSV::KeyGroup.new("plugin")]
  end

  it "should create two key groups with one key each for csv with headers and two rows for different files" do
    converter = PropsCSV::CSVToKeyGroup.new([["Arquivo", "Chave", ""], ["messages", "key", "value"], ["plugin", "another", "test"]])

    group = converter.groups[0]
    group.translation_for("key", "").should == "value"
    group.translation_for("another", "").should be_nil
    group = converter.groups[1]
    group.translation_for("key", "").should be_nil
    group.translation_for("another", "").should == "test"
  end

  it "should create one key group with encoded translation" do
    converter = PropsCSV::CSVToKeyGroup.new([["Arquivo", "Chave", ""], ["messages", "key", "valué"]])

    converter.groups[0].translation_for("key", "").should == "valué"
  end

  it "should create one key group with multiline translation" do
    converter = PropsCSV::CSVToKeyGroup.new([["Arquivo", "Chave", ""], ["messages", "key", "value\nwith\nmultiple lines"]])

    converter.groups[0].translation_for("key", "").should == "value\nwith\nmultiple lines"
  end
end