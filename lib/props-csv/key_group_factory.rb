require File.expand_path("../properties_to_key_group.rb", __FILE__)
require File.expand_path("../csv_to_key_group.rb", __FILE__)

module PropsCSV
  class KeyGroupFactory
    def self.from_properties(files, from_encoding="UTF-8", to_encoding="UTF-8")
      PropertiesToKeyGroup.new(files, lambda {|path| File.new(path)}, from_encoding, to_encoding)
    end
  
    def self.from_csv(csv)
      CSVToKeyGroup.new(csv)
    end
  end
end