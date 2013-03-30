require 'spec_helper'

describe Comment, :type => :request do

  before :each do
    @today = Time.now - 3000
    @post = Post.create(title: 'Post A', slug: 'lorem-ipsum-a', body: 'Lorem ipsum dolor sit amet', body_html: '<p>Lorem ipsum dolor sit amet</p>', published_at: @today, edited_at: @today)
  end

  it 'should post a comment with name only' do
    visit @post.permalink
    fill_in 'Name', :with => 'Jim Jimmers'
    fill_in 'comment_body', :with => 'Witty remarks'
    click_button 'Post Comment'
    page.should have_content 'Jim Jimmers'
    page.should have_content 'Witty remarks'
    page.should_not have_content 'Unable to save'
  end

  it 'should post a comment with all fields' do
    visit @post.permalink
    fill_in 'Name', :with => 'Jim Jimmers'
    fill_in 'Email', :with => 'jim@jimmers.com'
    fill_in 'Website', :with => 'http://jimmers.com'
    fill_in 'comment_body', :with => 'Witty remarks'
    click_button 'Post Comment'
    page.should have_content 'Jim Jimmers'
    page.should have_content 'Witty remarks'
    page.should_not have_content 'Unable to save'
  end

  it 'should not post a comment without a name, body, or a badly formatted email or web address' do
    visit @post.permalink
    fill_in 'Email', :with => 'asdfjajlskfda'
    fill_in 'Website', :with => 'jimmers.com'
    click_button 'Post Comment'
    page.should have_content 'Unable to save'
    page.should have_content 'Author must not be blank'
    page.should have_content 'Author email has an invalid format'
    page.should have_content 'Author url has an invalid format'
    page.should have_content 'Body must not be blank'
  end
end
