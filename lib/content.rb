# Common code for Posts, Pages and Comments
module HTMLBody
  def to_s
    body
  end

  # A short version of the body text
  def blurb
    body[0, 50] << '...'
  end

  private

  # Caches the Textile-parsed body
  def set_html!
    self.body_html = RedCloth.new(self.body.to_s).to_html
  end
end

# Common code for Posts and Pages
module Content
  def self.included(base)
    base.send :include, HTMLBody
  end

  def set_data!
    set_slug!
    set_html!
  end

  private

  # Converts and assigns a title like "The Title" into a slug like "the-title"
  def set_slug!
    if self.slug.blank?
      self.slug = title.clone
      self.slug.downcase!
      self.slug.gsub!(/&([0-9a-z#])+;/, '')  # Ditch Entities
      self.slug.gsub!('&', 'and')            # Replace & with 'and'
      self.slug.gsub!(/[^a-z0-9\-']/, '-')   # Get rid of anything we don't like
      self.slug.gsub!(/-+/, '-')             # collapse dashes
      self.slug.gsub!(/-$/, '')              # trim dashes
      self.slug.gsub!(/^-/, '')              # trim dashes
    end
  end
end
