require 'csv'
require File.expand_path("../key_group_factory.rb", __FILE__)
require File.expand_path("../property_exporter.rb", __FILE__)

if(ARGV.length == 0)
  puts """Reads a CSV with translation keys and saves translation property files to the given languages. The CSV must have at least three columns:

- The first with the path of the translation file to be saved
- The second with the translation key
- The third and all others after it, one for each language

The first row of the CSV should be a header row specifying the language of each language column.  

Usage:
\truby from_csv.rb <CSV_PATH> [options]

Options:
\t-in=<encoding>\tThe encoding of the CSV file. If no encoding is given, UTF-8 will be used.
\t-out=<encoding>\tThe desired encoding of the property files. If no encoding is given, UTF-8 will be used.
\t-l=<languages>\tA comma separated list of languages names as listed in the CSV header. If no language is given, property files for all languages in the CSV are generated.

Examples:
\truby from_csv.rb translations.csv
\truby from_csv.rb translations.csv -l=en
\truby from_csv.rb translations.csv -l=en,pt_BR -in=ISO-8859-1 -out=MacRoman
"""
else
  csv_path = ARGV[0]
  options = {
    'in' => "UTF-8",
    'out' => "UTF-8"
  }
  ARGV[1..-1].each do |option|
    match = option.match /-([^=]+)=(.*)/
    options[match[1]] = match[2]
  end
  
  contents = CSV.read(csv_path)

  factory = KeyGroupFactory.from_csv(contents)
  groups = factory.groups

  if(options['l'])
    languages = options['l'].split(",")
  else
    languages = contents[0][2..-1]
  end

  groups.each do |group|
    exporter = PropertyExporter.new(group, lambda {|path| File.open(path, 'w')}, options['out'], options['in'])
    languages.each do |language|
      # FIXME Exporting default language is not working.
      # Use _ for the default language (file.properties, for example).
      # \truby from_csv.rb translations.csv -l=_
      # language = "" if language == "_"
      exporter.export language
    end
  end
end