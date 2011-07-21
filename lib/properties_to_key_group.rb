require File.expand_path("../group_store.rb", __FILE__)
require File.expand_path("../property_parser.rb", __FILE__)

class PropertiesToKeyGroup
  def initialize(files, to_IO, from_encoding, to_encoding)
    @store = GroupStore.new
    load_groups(files, to_IO, from_encoding, to_encoding)
  end

  def groups
    @store.groups
  end
  
  private
  def load_groups(files, to_IO, from_encoding, to_encoding)
    files.each do |full_path|
      io = to_IO.call(full_path)
      parser = PropertyParser.new(from_encoding, to_encoding)
      values = parser.parse(io)

      path = File.join(File.dirname(full_path), File.basename(full_path, ".properties"))
      group = @store.group(path)
      language = path.gsub(/#{group.id}_?/, '')
      values.each_pair {|key, value| group.add_translation(key, language, value)}
    end
  end
end

