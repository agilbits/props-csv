require File.expand_path("../key_group.rb", __FILE__)
require File.expand_path("../property_parser.rb", __FILE__)

class KeyGroupFactory
  def initialize(files, to_IO)
    load_groups(files, to_IO)
  end

  def groups
    @groups.values
  end
  
  private
  def load_groups(files, to_IO)
    @groups = {}
    files.each do |full_path|
      io = to_IO.call(full_path)
      parser = PropertyParser.new
      values = parser.parse(io)

      path = File.join(File.dirname(full_path), File.basename(full_path, ".properties"))
      group = group(path)
      language = path.gsub(/#{group.id}_?/, '')
      values.each_pair {|key, value| group.add_translation(key, language, value)}
    end
  end
  
  def group(path)
    group = KeyGroup.new(path)
    if @groups[group.id]
      group = @groups[group.id]
    else
      @groups[group.id] = group
    end
    group
  end
end

