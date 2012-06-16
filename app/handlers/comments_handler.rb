class CommentsHandler < AbstractHandler
  # Post a comment
  post %r{^/([0-9]{4})/([0-9]{2})/([0-9]{2})/([^/]+)/?$} do |year, month, day, slug|
    @post = Post.find_by_permalink(year, month, day, slug)
    @comment = @post.comments.new(params[:comment])
    continue = Conf[:recaptcha] ? (session[:sentience_verified] ||= recaptcha_valid?) : true

    if continue and @comment.save
      mail Conf[:author, :email], 'New comment notification', :comment if Conf[:mail, :comments]
      redirect permalink_comment_path(@comment)
    else
      erb :"posts/show"
    end
  end

  # Render Textile as HTML
  post '/textile-preview' do
    RedCloth.new(params[:body].to_s).to_html
  end
end
