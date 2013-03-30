require 'spec_helper'

describe Page, :type => :request do
  before :each do
    [{title: 'Life, the Universe, and Everything', slug: 'life-the-universe-and-everything', body: 'We apologize for the inconvenience', body_html: '<p>We appologize for the inconvenience</p>'}].
    each { |attrs| Page.create(attrs) }
  end

  it 'should show a page at its path' do
    visit '/pages/life-the-universe-and-everything'
    page.should have_content 'Life, the Universe, and Everything'
    page.should have_content 'We apologize for the inconvenience'
  end

  it 'should show Not Found' do
    visit "/pages/bad"
    page.should have_content 'Not Found'
  end
end
