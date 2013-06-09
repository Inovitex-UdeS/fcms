require 'spec_helper'

describe "admin/editions/new" do
  before(:each) do
    assign(:admin_edition, stub_model(Admin::Edition).as_new_record)
  end

  it "renders new admin_edition form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", admin_editions_path, "post" do
    end
  end
end
