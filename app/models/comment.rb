class Comment
  include HTMLBody
  include DataMapper::Resource

  property :id, Serial
  property :post_id, Integer, :required => true, :index => true
  property :author, String, :required => true
  property :author_url, String
  property :author_email, String
  property :author_openid_authority, String
  property :body, Text, :required => true
  property :body_html, Text, :required => true
  property :created_at, DateTime
  property :updated_at, DateTime
  property :deleted, ParanoidBoolean, :index => true

  belongs_to :post

  before :valid?, :set_data!
  after :save, :denormalize
  after :destroy, :denormalize

  def self.recent(options = {})
    options = {:created_at.lt => Time.now, :limit => 20}.merge(options)
    Comment.ordered.all(options)
  end

  def self.ordered
    all(:order => :created_at.desc)
  end

  def set_data!
    set_html!
    # Hack around Enki schema
    self.author_url ||= ''
    self.author_email ||= ''
  end

  # Override HTMLBody::set_html! so we can filter or sanitize public comments
  def set_html!
    cloth = RedCloth.new(CGI::unescapeHTML(self.body.to_s))
    cloth.filter_html = true # Escape any HTML tags weren't generated from Textile
    self.body_html = cloth.to_html
  end

  def denormalize
    self.post.denormalize_comments_count!
  end
end
