class FolderScanner
  def initialize path
    @path = path
  end
  
  def property_files(map = {})
    property_files = File.join(@path, "**", "*.properties")
    files = Dir.glob(property_files).sort
    if map[:exclude]
      files = files.reject do |file|
        exclude?(file, map[:exclude])
      end
    end
    files
  end
  
  private
  def exclude? (file, exclude_patterns)
    exclude_patterns.inject(false) do |reject, pattern|
      reject ||= file.match(pattern)
    end
  end
end