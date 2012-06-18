class Comment
  include HTMLBody
  include DataMapper::Resource

  property :id, Serial
  property :post_id, Integer, :required => true, :index => true
  property :author, String, :length => 100, :required => true
  property :author_email, String, :length => 100, :format => :email_address
  property :author_url, String, :length => 100, :format => :url
  property :body, Text, :required => true
  property :body_html, Text, :required => true
  property :created_at, DateTime
  property :updated_at, DateTime
  property :deleted_at, ParanoidDateTime, :index => true

  belongs_to :post

  before :valid?, :set_data!
  after :save, :denormalize
  after :destroy, :denormalize

  # Returns the 20 most recent comments in descending order
  def self.recent(options = {})
    options = {:created_at.lt => Time.now, :limit => 20}.merge(options)
    Comment.ordered.all(options)
  end

  # Returns comments in descending order
  def self.ordered
    all(:order => :created_at.desc)
  end

  private

  # Cache the html
  def set_data!
    set_html!
  end

  # Reset the post's comment count
  def denormalize
    self.post.set_comments_count!
  end

  # Override HTMLBody::set_html! so we can filter or sanitize public comments
  def set_html!
    cloth = RedCloth.new(CGI::unescapeHTML(self.body.to_s))
    cloth.filter_html = true # Escape any HTML tags weren't generated from Textile
    self.body_html = cloth.to_html
  end
end
