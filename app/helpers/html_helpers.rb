module HTMLHelpers
  # A cache of mtimes for assets
  ASSET_TIMESTAMPS = {}
  ASSET_MUTEX = Mutex.new

  # Displays a list of errors on a record
  def errors_for(obj)
    if obj.errors.any?
      errors = obj.errors.values.flatten
      %Q|<span>Unable to save because of the following errors:</span><ul>#{errors.map { |e| "<li>#{e}</li>" }.join}</ul>|
    end
  end

  # Returns an "a" tag
  def link_to(text, path, options={})
    options[:"data-confirm"] = options.delete(:confirm) if options.has_key? :confirm
    options[:"data-method"] = options.delete(:method) if options.has_key? :method
    options[:href] = path
    tag('a', text, options)
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
    tag('img', nil, options)
  end

  # A generic HTML tag generator. If nil content is passed, a self-closing tag is generated
  def tag(tag_name, content, options={})
    invalidate_asset_cache! options
    attrs = options.map { |attr,val| %Q|#{attr}="#{val.to_s.gsub(/"/, '\"')}"| }
    open_tag = "<#{tag_name} #{attrs.join(' ')}"
    content.nil? ? "#{open_tag} />" : "#{open_tag}>#{content}</#{tag_name}>"
  end

  # Append a Unix timestamp to the specified path
  def invalidate_asset_cache!(options)
    if attr = options.delete(:invalidate)
      path = ROOT['public', options[attr]]
      if stamp = ASSET_MUTEX.synchronize { ASSET_TIMESTAMPS[path] ||= File.mtime(path).to_i rescue nil }
        options[attr] += options[attr].include?('?') ? "&#{stamp}" : "?#{stamp}"
      end
    end
  end
end
