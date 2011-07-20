require File.expand_path("../key_group.rb", __FILE__)

class KeyGroupFactory
  def initialize(files, to_IO)
    @files = files
    @to_IO = to_IO
  end

  def groups
    groups = {}
    @files.each do |full_path|
      path = File.join(File.dirname(full_path), File.basename(full_path, ".properties"))
      group = KeyGroup.new(path)
      if groups[group.id]
        group = groups[group.id]
      else
        groups[group.id] = group unless groups[group.id]
      end
      
      language = path.gsub(/#{group.id}_?/, '')
      io = @to_IO.call(full_path)
      while(line = io.gets) do
        key, value = extract_pair(line)
        group.add_translation(key, language, value) if key
      end
    end
    groups.values
  end
  
  private
  def extract_pair(property)
    # FIXME Force encoding? SUCKS!
    property.force_encoding("ISO-8859-1")
    match = property.match(/^([^=]+)=([^\n]*)\n?$/)
    [match[1].strip, match[2].strip] if match
  end
end