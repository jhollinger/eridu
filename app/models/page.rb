class Page
  include Content
  include DataMapper::Resource

  property :id, Serial
  property :title, String, :length => 255, :required => true
  property :slug, String, :length => 255, :required => true, :index => true, :unique => true
  property :body, Text, :required => true
  property :body_html, Text, :required => true
  property :created_at, DateTime
  property :updated_at, DateTime
  property :deleted_at, ParanoidDateTime

  before :valid?, :set_data!

  def self.find_by_slug(slug)
    first(:slug => slug) || raise(Sinatra::NotFound)
  end

  def self.ordered
    all(:order => :title)
  end

  def active?
    true
  end
end
