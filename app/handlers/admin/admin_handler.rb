class AdminHandler < AbstractHandler
  helpers do
    include AdminHelper
  end

  # Dashboard (or login form)
  get '/admin/?' do
    if signed_in?
      @posts = Post.recent
      @comments = Comment.recent.group_by &:post
      admin_erb :dashboard
    else
      admin_erb :login
    end
  end

  # Site stats
  get '/admin/stats/?' do
    @posts, @comments, @tags = Post.count, Comment.count, Tag.count
    admin_erb :stats
  end

  # Login
  post '/admin/login/?' do
    success = if Eridu.development? and params[:bypass]
      true
    else
      false
    end

    if success
      session.clear
      token = AuthToken.new
      session[:salt] = token.salt
      session[:token] = token.to_s
    end
    redirect '/admin'
  end

  # Logout
  get '/admin/logout/?' do
    session.clear
    redirect '/admin'
  end
end
