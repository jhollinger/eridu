class CommentsHandler < AbstractHandler
  # Post a comment
  post %r{^/([0-9]{4})/([0-9]{2})/([0-9]{2})/(.+)/comments/?$} do |year, month, day, slug|
    @post = Post.find_by_permalink(year, month, day, slug)
    @comment = @post.comments.new(params[:comment])
    if @comment.save
      mail Conf[:author, :email], 'New comment notification', :comment if Conf[:mail, :comments]
      redirect permalink_path(@post)
    else
      erb :"posts/show"
    end
  end

  # Render Textile as HTML
  post '/textile-preview' do
    RedCloth.new(params[:body].to_s).to_html
  end
end
