require 'spec_helper'

describe 'Admin', :type => :request do
  it 'should disallow Dashboard access if user is not signed in' do
    visit '/admin'
    page.should_not have_content 'Dashboard'
    page.should have_content 'Halt! Who goes there?'
  end

  it 'should disallow Dashboard access if user is not signed in' do
    visit '/admin/'
    page.should_not have_content 'Dashboard'
    page.should have_content 'Halt! Who goes there?'
  end

  it 'should disallow admin access if user is not signed in' do
    visit '/admin/posts'
    page.should_not have_content 'Dashboard'
    page.should have_content 'Halt! Who goes there?'
  end

  it 'should be able to log by bypassing credentials' do
    as_admin
    page.should have_content 'Dashboard'
    page.should have_content 'Latest Posts'
    page.should have_content 'Latest Comments'
  end
end
