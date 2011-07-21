require 'csv'
require File.expand_path("../folder_scanner.rb", __FILE__)
require File.expand_path("../key_group_factory.rb", __FILE__)

if(ARGV.length == 0)
  puts """Scans a given directory recursively for property files (.properties) with translations and generates one CSV with everything. The CSV will have at least three columns:

- The first with the path of the property file relative to the current directory
- The second with the translation key
- The third and all others after it, one for each language found

The first row of the CSV will be a header row specifying the language of each language column. The following row will contain available translations for each key of each file.

Usage:
\truby to_csv.rb <DIRECTORY_PATH> [options]

Options:
\t-f=<filepath>\tThe desired path to the CSV file. If no file path is given, the CSV will be written to standard output.
\t-in=<encoding>\tThe encoding of the property files. If no encoding is given, UTF-8 will be used.
\t-out=<encoding>\tThe desired encoding of the CSV file. If no encoding is given, UTF-8 will be used.
\t-x=<excludes>\tA comma separated list of patterns to be excluded from the search for property files. Must not contain spaces.
\t\t\tIf the path for a property file contains one of the excluded patterns, this property file will be ignored.

Examples:
\truby to_csv.rb .
\truby to_csv.rb . -f=translations.csv
\truby to_csv.rb ./resources -f=translations.csv -x=/bin/,/build -in=ISO-8859-1 -out=MacRoman
"""
else
  directory_path = ARGV[0]
  options = {
    'in' => "UTF-8",
    'out' => "UTF-8",
    'x' => ""
  }
  ARGV[1..-1].each do |option|
    match = option.match /-([^=]+)=(.*)/
    options[match[1]] = match[2]
  end

  scanner = FolderScanner.new(directory_path)
  files = scanner.property_files(:exclude => options['x'].split(","))

  factory = KeyGroupFactory.from_properties(files, options['in'], options['out'])
  groups = factory.groups

  def to_csv(csv, groups)
    headers = ["File path", "Key"]
    languages = groups.map(&:languages).flatten.uniq
    languages.each {|language| headers << language}
    csv << headers
    groups.each do |group|
      group.keys.each do |key|
        row = [group.id, key]
        languages.each do |language|
          row << group.translation_for(key, language)
        end
        csv << row
      end
    end
  end

  if(options['f'])
    CSV.open(options['f'], "wb") { |csv| to_csv(csv, groups) }
  else
    puts CSV.generate { |csv| to_csv(csv, groups) }
  end
end
