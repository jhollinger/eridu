class Post
  include Content
  include DataMapper::Resource

  attr_accessor :minor_edit

  property :id, Serial
  property :title, String, :length => 255, :required => true
  property :slug, String, :length => 255, :required => true, :index => true, :unique => true
  property :teaser, Text
  property :teaser_html, Text
  property :body, Text, :required => true
  property :body_html, Text, :required => true
  property :comments_count, Integer, :default => 0, :required => true
  property :published_at, DateTime
  property :edited_at, DateTime, :required => true
  property :created_at, DateTime
  property :updated_at, DateTime
  property :deleted_at, ParanoidDateTime, :index => true

  has n, :comments
  has_tags_on :tags

  before :valid?, :set_data!
  before :destroy, :destroy_comments

  # Returns recently published Posts
  def self.recent(options = {})
    options = {:limit => 10}.merge(options)
    Post.published.ordered.all(options)
  end

  # Finds a post by its date and slug. Raises Sinatra::NotFound if it can't be found
  def self.find_by_permalink(year, month, day, slug, options = {})
    begin
      date = Date.parse("#{year}-#{month}-#{day}")
      post = Post.first(:slug => slug, :published_at.gte => date.to_time, :published_at.lt => (date+1).to_time)
    rescue ArgumentError # Invalid time
      post = nil
    end
    post || raise(Sinatra::NotFound)
  end

  # Returns only published Posts
  def self.published
    all(:published_at.lt => Time.now)
  end

  # Returns Posts ordered by published date
  def self.ordered
    all(:order => :published_at.desc)
  end

  # Returns this posts permalink
  def permalink(host=nil)
    host = host.gsub(%r{/$}, '') unless host.nil?
    date = self.published_at
    "#{host}/#{date.year}/#{date.strftime('%m')}/#{date.strftime('%d')}/#{self.slug}"
  end

  # Returns true if this Post has a teaser
  def teaser?
    !self.teaser.blank?
  end

  # Returns true if the current edit was minor
  def minor_edit?
    minor_edit == '1'
  end

  # Set the published date using a Chronic string, like "now"
  def published_at_natural=(chronic_str)
    self.published_at = Chronic.parse(chronic_str) || Time.now
  end

  def set_comments_count!
    self.comments_count = comments.count
    save!
  end

  private

  def set_data!
    super
    set_dates!
  end

  def set_dates!
    self.edited_at = Time.now if edited_at.nil? || !minor_edit?
  end

  # Override to cache the teaser html
  def set_html!
    super
    self.teaser_html = if self.teaser?
      textile = self.teaser + %Q|<p><a href="#{self.permalink}">read more &rarr;</a></p>|
       RedCloth.new(textile).to_html
    else
      nil
    end
  end

  def destroy_comments
    comments.update! :deleted_at => Time.now
  end
end
