require File.expand_path("../key_group.rb", __FILE__)

class GroupStore
  def initialize
    @groups = {}
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
  
  def groups
    @groups.values
  end
end