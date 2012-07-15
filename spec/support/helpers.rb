module RSpecHelpers
  # Sign in as admin
  def as_admin
    visit '/admin'
    check 'Bypass credentials'
    click_button 'Login with OpenID'
  end
end

RSpec.configure do |config|
  config.include RSpecHelpers
end
