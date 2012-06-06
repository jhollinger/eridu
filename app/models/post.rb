class Post
  include Content
  include DataMapper::Resource

  attr_accessor :minor_edit

  property :id, Serial
  property :title, String, :length => 255, :required => true
  property :slug, String, :length => 255, :required => true, :index => true, :unique => true
  property :body, Text, :required => true
  property :body_html, Text, :required => true
  property :active, Boolean, :default => true, :required => true
  property :approved_comments_count, Integer, :default => 0, :required => true
  property :published_at, DateTime
  property :edited_at, DateTime, :required => true
  property :created_at, DateTime
  property :updated_at, DateTime
  property :deleted_at, ParanoidDateTime

  has n, :comments
  has_tags_on :tags

  before :valid?, :set_data!
  before :destroy, :destroy_comments

  def self.recent(options = {})
    options = {:published_at.lt => Time.now, :limit => 10}.merge(options)
    Post.ordered.all(options)
  end

  def self.find_by_permalink(year, month, day, slug, options = {})
    begin
      date = Date.parse("#{year}-#{month}-#{day}")
      post = Post.first(:slug => slug, :published_at.gte => date.to_time, :published_at.lt => (date+1).to_time)
    rescue ArgumentError # Invalid time
      post = nil
    end
    post || raise(Sinatra::NotFound)
  end

  def self.ordered
    all(:order => :published_at.desc)
  end

  def published?
    published_at?
  end

  def minor_edit?
    minor_edit == '1'
  end

  def published_at_natural=(chronic_str)
    self.published_at = Chronic.parse(chronic_str) || Time.now
  end

  def denormalize_comments_count!
    self.approved_comments_count = comments.count
    save
  end

  def set_data!
    super
    set_dates!
  end

  private

  def set_dates!
    self.edited_at = Time.now if edited_at.nil? || !minor_edit?
  end

  def destroy_comments
    comments.update! :deleted_at => Time.now
  end
end
