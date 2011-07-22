module PropsCSV
  class KeyGroup
    include Comparable
    attr_reader :id
  
    def initialize(path)
      prefix = File.basename(path).gsub(/_.*/, '')
      @id = File.join(File.dirname(path), prefix)
      @keys = {}
      @languages = []
    end
  
    def <=> (other)
      @id <=> other.id
    end
  
    def add_key key
      @keys[key] = {} unless @keys[key]
    end
  
    def keys
      @keys.keys
    end
  
    def add_translation(key, language, value)
      add_key(key)
      @keys[key][language] = value
      @languages << language unless @languages.include? language
    end
  
    def translation_for(key, language)
      @keys[key][language] if @keys[key]
    end
  
    def languages
      @languages.sort
    end
  end
end