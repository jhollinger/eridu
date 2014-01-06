class PublicHandler < AbstractHandler
  # Home page
  get '/' do
    if @page = Page.home
      erb :"pages/show"
    else
      @posts = Post.recent
      erb :"posts/index"
    end
  end

  # A post
  get %r{^/([0-9]{4})/([0-9]{2})/([0-9]{2})/([^/]+)/?$} do |year, month, day, slug|
    @post = Post.find_by_permalink(year, month, day, slug)
    title @post.title
    erb :"posts/show"
  end

  # A page
  get '/pages/:slug/?' do |slug|
    @page = Page.find_by_slug(slug)
    title @page.title
    erb :"pages/show"
  end

  # All posts grouped by month and year
  get '/archives/?' do
    @posts = Post.published.ordered.group_by { |post| post.published_at.strftime('%B %Y') }
    title 'Archives'
    erb :"posts/archives"
  end

  # Recently tagged posts and Atom feed
  get %r{^/(\w+)(\.atom)?/?$} do |tag, atom|
    @tag = tag
    @posts = @tag == 'posts' ? Post.recent : Post.recent.tagged_with(@tag)
    title @tag.capitalize
    atom ? builder(:"posts/feed") : erb(:"posts/tagged")
  end
end
