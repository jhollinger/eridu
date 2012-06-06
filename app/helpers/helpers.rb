module Helpers
  # Public path to a post
  def permalink_path(post)
    date = post.published_at
    "/#{date.year}/#{date.strftime('%m')}/#{date.strftime('%d')}/#{post.slug}"
  end

  # Public path to a comment
  def permalink_comment_path(comment)
    "#{permalink_path(comment.post)}#comment-#{comment.id}"
  end

  # Public path to a page
  def page_path(page)
    "/pages/#{page.slug}"
  end

  # Set the page title
  def title(title=nil)
    @title ||= title unless title.nil?
    @title
  end

  # Whether or not to show the reCAPTCHA form
  def show_recaptcha?
    Conf[:recaptcha] && !session[:sentience_verified] 
  end

  # Returns true if the user is signed in, false if not
  def signed_in?
    return false unless session[:token] and session[:salt]
    AuthToken.new(session[:salt]) === session[:token]
  end

  # Send an email. Examples:
  #  mail user@example.com, 'Foo', :a_template
  #  mail user@example.com, 'Foo', 'Some text'
  #  mail user@example.com, 'Foo', 'Some text', '<p>Some text</p>'
  def mail(address, subject_text, text_or_template, html=nil)
    return false if Eridu.development?
    # Get or render the content
    body_text = text_or_template.is_a?(Symbol) ? erb(:"mailers/#{text_or_template}.text", :layout => false) : text_or_template
    body_html = text_or_template.is_a?(Symbol) \
      ? File.exists?(ROOT['app', 'views', 'mailers', "#{text_or_template}.html.erb"]) ? erb(:"mailers/#{text_or_template}.html", :layout => false) : nil \
      : nil
    # Send the mail
    Mail.deliver do
      from Conf[:mail, :from]
      to address
      subject subject_text
      # A plain text email
      if body_html.nil?
        body body_text
      # A multipart email of text and html
      else 
        text_part { body body_text }
        html_part do
          content_type 'text/html; charset=UTF-8'
          body body_html
        end
      end
    end
  end
end
