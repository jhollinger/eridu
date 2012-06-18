# Extend the dm-tags Tag class
class Tag
  # Returns tags ordered by name
  def self.ordered
    all(:order => :name)
  end

  def to_s
    name
  end
end
