require File.dirname(__FILE__) + '/spec_helper'

describe 'Admin', :type => :request do
  it 'should be able to log by bypassing credentials' do
    visit '/admin'
    check 'Bypass credentials'
    click_button 'Login with OpenID'
    page.should have_content 'Dashboard'
  end
end
