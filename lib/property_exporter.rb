require 'iconv'

class PropertyExporter
  def initialize(group, to_IO, to_encoding="UTF-8", from_encoding="UTF-8")
    @group = group
    @to_IO = to_IO
    @to_encoding = to_encoding
    @from_encoding = from_encoding
  end
    
  def export(language)
    io = @to_IO.call(path(language))
    io.set_encoding(@to_encoding)
    @group.keys.each do |key|
      translation = @group.translation_for(key, language)
      if translation
        escaped_translation = translation.gsub("\n","\\n\\\n")
        io.puts "#{key}=#{Iconv.conv(@to_encoding, @from_encoding, escaped_translation)}"
      end
    end
  end
  
  def path(language)
    prefix = @group.id
    language = "_#{language}" if(language.size > 0)
    suffix = ".properties"
    prefix + language + suffix
  end
end