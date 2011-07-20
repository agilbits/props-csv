require 'csv'
require File.expand_path("../folder_scanner.rb", __FILE__)
require File.expand_path("../key_group_factory.rb", __FILE__)

scanner = FolderScanner.new(ARGV[0])
files = scanner.property_files(:exclude => ['/build', '/bin/'])

factory = KeyGroupFactory.new(files, lambda {|path| File.new(path)} )
groups = factory.groups

CSV.open("translations.csv", "wb") do |csv|
  headers = ["Arquivo", "Chave"]
  languages = groups.map(&:languages).flatten.uniq
  languages.each {|language| headers << language}
  csv << headers
  groups.each do |group|
    group.keys.each do |key|
      line = [group.id, key]
      languages.each do |language|
        line << group.translation_for(key, language)
      end
      csv << line
    end
  end
end

