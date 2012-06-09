# Extend the dm-tags Tagging class
class Tagging
  # Delete unused Tags
  after :destroy do
    tag.destroy unless tag.taggings.count > 0
  end
end
