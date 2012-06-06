module HTMLHelpers
  # Displays a list of errors on a record
  def errors_for(obj)
    if obj.errors.any?
      errors = obj.errors.values.flatten
      %Q|<span>Unable to save because of the following errors:</span><ul>#{errors.map { |e| "<li>#{e}</li>" }}</ul>|
    end
  end

  # Returns an "a" tag
  def link_to(text, path, options={})
    options[:"data-confirm"] = options.delete(:confirm) if options.has_key? :confirm
    options[:"data-method"] = options.delete(:method) if options.has_key? :method
    options[:href] = path
    tag('a', options, text)
  end

  # Returns an img tag with the src as the specified icon
  def icon_tag(icon, options={})
    title = icon.to_s.capitalize
    options = {:title => title, :alt => title, :class => ''}.merge(options)
    options[:class] << ' icon'
    image_tag("#{icon}-icon.png", options)
  end

  # Returns an img tag with the src as the specified img
  def image_tag(image, options={})
    options[:src] = "/images/#{image}"
    tag('img', options)
  end

  # A generic HTML tag generator. If falsey content is passed, a self-closing tag is generated
  def tag(tag_name, options, content=nil)
    attrs = options.map { |attr,val| %Q|#{attr}="#{val.to_s.gsub(/"/, '\"')}"| }
    open_tag = "<#{tag_name} #{attrs.join(' ')}"
    content ? "#{open_tag}>#{content}</#{tag_name}>" : "#{open_tag} />"
  end
end
