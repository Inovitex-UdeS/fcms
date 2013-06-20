require 'spec_helper'

describe "admin/editions/index" do
  before(:each) do
    assign(:admin_editions, [
      stub_model(Admin::Edition),
      stub_model(Admin::Edition)
    ])
  end

  it "renders a list of admin/editions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
