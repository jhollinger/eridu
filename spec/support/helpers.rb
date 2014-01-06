module RSpecHelpers
  # Sign in as admin
  def as_admin
    page.driver.browser.basic_authorize(Conf[:author][:username], Conf[:author][:password])
    visit '/admin'
  end
end

RSpec.configure do |config|
  config.include RSpecHelpers
end
