# Extend the dm-tags Tag class
class Tag
  def self.ordered
    all(:order => :name)
  end

  def to_s
    name
  end
end
