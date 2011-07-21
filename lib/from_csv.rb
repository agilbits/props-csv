require 'csv'
require File.expand_path("../key_group_factory.rb", __FILE__)
require File.expand_path("../property_exporter.rb", __FILE__)

csv_path = ARGV[0]
contents = CSV.read(csv_path)

factory = KeyGroupFactory.from_csv(contents)
groups = factory.groups

groups.each do |group|
  exporter = PropertyExporter.new(group, lambda {|path| File.open(path, 'w')}, "ISO-8859-1")
  ['fr'].each do |language|
    exporter.export language
  end
end