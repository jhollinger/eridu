require File.dirname(__FILE__) + '/spec_helper'

describe Post, :type => :request do
  before :each do
    @today = Time.now - 3000
    @future = @today + 9000000
    [{title: 'Post A', body: 'Lorem ipsum dolor sit amet', published_at: @today, edited_at: @today},
     {title: 'Post B', body: 'Lorem ipsum dolor sit amet', :tag_list => 'foo', published_at: @today, edited_at: @today},
     {title: 'Post C', body: 'Lorem ipsum dolor sit amet', published_at: @today, edited_at: @today},
     {title: 'Post D', body: 'Lorem ipsum dolor sit amet', published_at: @today, edited_at: @today},
     {title: 'Post E', body: 'Lorem ipsum dolor sit amet', published_at: @today, edited_at: @today},
     {title: 'Post F', body: 'Lorem ipsum dolor sit amet', published_at: @today, edited_at: @today},
     {title: 'Post G', body: 'Lorem ipsum dolor sit amet', published_at: @today, edited_at: @today},
     {title: 'Post H', body: 'Lorem ipsum dolor sit amet', published_at: @today, edited_at: @today},
     {title: 'Post I', body: 'Lorem ipsum dolor sit amet', published_at: @today, edited_at: @today},
     {title: 'Post J', body: 'Lorem ipsum dolor sit amet', :tag_list => 'foo', published_at: @today, edited_at: @today},
     {title: 'Post K', body: 'Lorem ipsum dolor sit amet', :tag_list => 'foo', published_at: @today, edited_at: @today},
     {title: 'Post L', body: 'Lorem ipsum dolor sit amet', :tag_list => 'foo', published_at: @future, edited_at: @today}].
    each { |attrs| Post.create(attrs) }
  end

  it 'should show the 10 most recent published comments' do
    visit '/'
    page.should have_content 'Post C'
    page.should_not have_content 'Post K'
    page.should_not have_content 'Post L'
  end

  it 'should show a post at the permalink path' do
    visit "/#{@today.strftime('%Y/%m/%d')}/post-j"
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
