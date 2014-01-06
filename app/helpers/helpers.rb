module Helpers
  # Set the page title
  def title(title=nil)
    @title ||= title unless title.nil?
    @title
  end

  # Public path to a post
  def permalink_path(post, hash=nil)
    "#{post.permalink}#{hash}"
  end

  # Public path to a comment
  def permalink_comment_path(comment)
    permalink_path(comment.post, "#comment-#{comment.id}")
  end

  # Public path to a page
  def page_path(page)
    "/pages/#{page.slug}"
  end

  # Returns an array of links for the header
  def header_links
    [%w[home /], %w[archives /archives], *Page.ordered.map { |p| [p.title.downcase, page_path(p)] }, *Conf[:links]]
  end

  # Obfuscate an email address
  def obfuscate(str)
    str.gsub('@', ' at ').gsub('.', ' dot ')
  end
end
