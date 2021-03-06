class Page
  HOME_SLUG = 'home'
  include Content
  include DataMapper::Resource

  property :id, Serial
  property :title, String, :length => 255, :required => true
  property :slug, String, :length => 255, :required => true, :index => true, :unique => true
  property :body, Text, :required => true
  property :body_html, Text, :required => true
  property :created_at, DateTime
  property :updated_at, DateTime
  property :deleted_at, ParanoidDateTime, :index => true

  before :valid?, :set_data!

  # Return the home page, or nil if none
  def self.home
    Page.first(:slug => HOME_SLUG)
  end

  # Finds a page by its slug. Raises Sinatra::NotFound if it can't be found
  def self.find_by_slug(slug)
    first(:slug => slug) || raise(Sinatra::NotFound)
  end

  # Returns pages ordered by title
  def self.ordered
    all(:order => :title)
  end
end
