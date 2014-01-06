class AdminHandler < AbstractHandler
  helpers do
    include AdminHelper
  end

  # Restrict access to /admin
  before '/admin/*' do
    require_sign_in! unless signed_in?
  end

  # Dashboard (or login form)
  get '/admin/?' do
    if signed_in?
      @posts = Post.recent
      admin_erb :dashboard
    else
      require_sign_in!
    end
  end

  # Preview Textile as HTML
  post '/textile-preview' do
    RedCloth.new(params[:body].to_s).to_html
  end
end
