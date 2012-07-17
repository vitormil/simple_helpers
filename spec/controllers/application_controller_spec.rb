require "spec_helper"

describe ApplicationController, "helper methods" do

  before(:each) do
    controller = double("ApplicationController")
  end

  it "should return the customized title" do
    controller.page_title = "My awesome page title"
    expect(controller.page_title).to eql("My awesome page title")
  end

  it "should return the customized subtitle" do
    controller.page_subtitle = "My awesome page subtitle"
    expect(controller.page_subtitle).to eql("My awesome page subtitle")
  end

  it "should fail" do
    test = "test"
    expect(test).to eql("fail")
  end
end
