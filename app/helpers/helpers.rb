module Helpers
  # Public path to a post
  def permalink_path(post)
    date = post.published_at
    "/#{date.year}/#{date.strftime('%m')}/#{date.strftime('%d')}/#{post.slug}"
  end

  # Public path to a page
  def page_path(page)
    "/pages/#{page.slug}"
  end

  # Path to which a comment is posted, for a given post
  def post_comment_path(post)
    "#{permalink_path(post)}/comments"
  end

  # Set the page title
  def title(title=nil)
    @title ||= title unless title.nil?
    @title
  end

  # Returns true if the user is signed in, false if not
  def signed_in?
    return false unless session[:token] and session[:salt]
    AuthToken.new(session[:salt]) === session[:token]
  end

  # Send an email
  def mail(address, subject_text, text_or_template)
    return false if Sinatra.development?
    # Render templates
    body_text = text_or_template.is_a?(Symbol) ? erb(:"mailers/#{text_or_template}.text", :layout => :"mailers/layout.text") : text_or_template
    # Send the mail
    Mail.deliver do
      from Conf[:mail, :from]
      to address
      subject subject_text
      body body_text
    end
  end
end
