require File.dirname(__FILE__) + '/spec_helper'

describe Post, :type => :request do
  before :each do
    @today = Time.now - 3000
    @future = @today + 9000000
    [{title: 'Post A', slug: 'lorem-ipsum-a', body: 'Lorem ipsum dolor sit amet', body_html: '<p>Lorem ipsum dolor sit amet</p>', published_at: @today, edited_at: @today},
     {title: 'Post B', slug: 'lorem-ipsum-b', body: 'Lorem ipsum dolor sit amet', body_html: '<p>Lorem ipsum dolor sit amet</p>', :tag_list => 'foo', published_at: @today, edited_at: @today},
     {title: 'Post C', slug: 'lorem-ipsum-c', body: 'Lorem ipsum dolor sit amet', body_html: '<p>Lorem ipsum dolor sit amet</p>', published_at: @today, edited_at: @today},
     {title: 'Post D', slug: 'lorem-ipsum-d', body: 'Lorem ipsum dolor sit amet', body_html: '<p>Lorem ipsum dolor sit amet</p>', published_at: @today, edited_at: @today},
     {title: 'Post E', slug: 'lorem-ipsum-e', body: 'Lorem ipsum dolor sit amet', body_html: '<p>Lorem ipsum dolor sit amet</p>', published_at: @today, edited_at: @today},
     {title: 'Post F', slug: 'lorem-ipsum-f', body: 'Lorem ipsum dolor sit amet', body_html: '<p>Lorem ipsum dolor sit amet</p>', published_at: @today, edited_at: @today},
     {title: 'Post G', slug: 'lorem-ipsum-g', body: 'Lorem ipsum dolor sit amet', body_html: '<p>Lorem ipsum dolor sit amet</p>', published_at: @today, edited_at: @today},
     {title: 'Post H', slug: 'lorem-ipsum-h', body: 'Lorem ipsum dolor sit amet', body_html: '<p>Lorem ipsum dolor sit amet</p>', published_at: @today, edited_at: @today},
     {title: 'Post I', slug: 'lorem-ipsum-i', body: 'Lorem ipsum dolor sit amet', body_html: '<p>Lorem ipsum dolor sit amet</p>', published_at: @today, edited_at: @today},
     {title: 'Post J', slug: 'lorem-ipsum-j', body: 'Lorem ipsum dolor sit amet', body_html: '<p>Lorem ipsum dolor sit amet</p>', :tag_list => 'foo', published_at: @today, edited_at: @today},
     {title: 'Post K', slug: 'lorem-ipsum-k', body: 'Lorem ipsum dolor sit amet', body_html: '<p>Lorem ipsum dolor sit amet</p>', :tag_list => 'foo', published_at: @today, edited_at: @today},
     {title: 'Post L', slug: 'lorem-ipsum-l', body: 'Lorem ipsum dolor sit amet', body_html: '<p>Lorem ipsum dolor sit amet</p>', :tag_list => 'foo', published_at: @future, edited_at: @today}].
    each { |attrs| Post.create(attrs) }
  end

  it 'should show the 10 most recent published comments' do
    visit '/'
    page.should have_content 'Post C'
    page.should_not have_content 'Post K'
    page.should_not have_content 'Post L'
  end

  it 'should show a post at the permalink path' do
    visit "/#{@today.strftime('%Y/%m/%d')}/lorem-ipsum-j"
    page.should have_content 'Lorem ipsum dolor sit amet'
  end

  it 'should show Not Found' do
    visit "/#{@today.strftime('%Y/%m/%d')}/bad-slug"
    page.should have_content 'Not Found'
  end

  it 'should show the archives' do
    visit '/archives'
    page.should have_content 'Archives'
    page.should have_content @today.strftime('%B %Y')
    page.should_not have_content 'Post L' # Because it's not published yet
  end

  it 'should show recent posts tagged with "foo"' do
    visit '/foo'
    page.should have_content 'Post B'
    page.should have_content 'Post J'
    page.should have_content 'Post K'
    page.should_not have_content 'Post C' # Because it's not tagged with "foo"
    page.should_not have_content 'Post L' # Because it's not published yet
  end

  it 'should generate the global atom feed' do
    visit '/posts.atom'
    page.should have_content 'Post A'
    page.should have_content 'Post B'
    page.should have_content 'Post J'
    page.should_not have_content 'Post K' # Because it's too old
    page.should_not have_content 'Post L' # Because it's not published yet
  end

  it 'should generate a tagged atom feed' do
    visit '/foo.atom'
    page.should_not have_content 'Post A' # Because it isn't tagged with foo
    page.should have_content 'Post B'
    page.should have_content 'Post K'
    page.should_not have_content 'Post L' # Because it isn't published yet
  end
end
