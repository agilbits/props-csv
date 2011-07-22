module PropsCSV
  class PropertyParser
    def initialize(from_encoding, to_encoding)
      @values = {}
      @from_encoding = from_encoding
      @to_encoding = to_encoding
    end
  
    def parse(io)
      key = nil
      value = nil
      io.set_encoding(@from_encoding)
      while(line = read_line(io)) do
        key, value = parse_line(line, key, value)
      
        if(value.end_with?('\\'))
          value[-1] = ' '
        elsif key
          @values[key] = value.gsub("\\n", "\n")
          key = nil
        end
      end
    
      @values[key] = value.gsub("\\n", "\n") if key
      @values
    end
  
    private
    def read_line(io)
      line = io.gets
      line.encode(@to_encoding) if line
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
end