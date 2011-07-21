require File.expand_path("../group_store.rb", __FILE__)

class CSVToKeyGroup
  def initialize(csv)
    @store = GroupStore.new
    load_groups(csv) if csv.size > 1
  end
  
  def groups
    @store.groups
  end
  
  private
  def load_groups(csv)
    headers = csv[0]
    csv[1..-1].each do |row|
      group = @store.group(row[0])
      (2..headers.size).each do |language_index|
        language = headers[language_index]
        group.add_translation(row[1], language, row[language_index])
      end
    end
  end
end