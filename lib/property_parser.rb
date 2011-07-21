class PropertyParser
  def initialize
    @values = {}
  end
  
  def parse(io)
    key = nil
    value = nil
    while(line = read_line(io)) do
      key, value = parse_line(line, key, value)
      
      if(value.end_with?('\\'))
        value[-1] = ' '
      elsif key
        @values[key] = value
        key = nil
      end
    end
    
    @values[key] = value if key
    @values
  end
  
  private
  def read_line(io)
    line = io.gets
    if(line)
      # FIXME Force encoding? SUCKS!
      line.force_encoding("ISO-8859-1")
      line.encode("UTF-8")
    end
  end
  
  def parse_line(line, key, value)
    if(key)
      [key, value + line.rstrip]
    else
      extract_pair(line)
    end
  end
  
  def extract_pair(line)
    match = line.match(/^([^=]+)=([^\n]*)\n?$/)
    if match
      [match[1].strip, match[2].strip] 
    else
      [nil, ""]
    end
  end
end
