require File.dirname(__FILE__) + '/spec_helper'

describe AuthToken do
  it "should be valid if it was generated today" do
    original_token = AuthToken.new
    suspect_token = AuthToken.new(original_token.salt)

    original_token.===(suspect_token).should == true
  end

  it "should be valid if it was generated yesterday" do
    original_token = AuthToken.new
    original_token.instance_variable_set('@date', Date.today - 1)
    suspect_token = AuthToken.new(original_token.salt)

    original_token.===(suspect_token).should == true
  end

  it "should be not be valid if it was generated two days ago" do
    original_token = AuthToken.new
    original_token.instance_variable_set('@date', Date.today - 2)
    suspect_token = AuthToken.new(original_token.salt)

    original_token.===(suspect_token).should == false
  end

  it "should be not be valid if it was generated tomorrow" do
    original_token = AuthToken.new
    original_token.instance_variable_set('@date', Date.today + 1)
    suspect_token = AuthToken.new(original_token.salt)

    original_token.===(suspect_token).should == false
  end

  it "should be not be valid if it has the wrong salt" do
    original_token = AuthToken.new
    suspect_token = AuthToken.new('pepper')

    original_token.===(suspect_token).should == false
  end
end
