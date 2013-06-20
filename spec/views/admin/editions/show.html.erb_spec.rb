require 'spec_helper'

describe "admin/editions/show" do
  before(:each) do
    @admin_edition = assign(:admin_edition, stub_model(Admin::Edition))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
