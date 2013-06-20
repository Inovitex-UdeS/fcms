require 'spec_helper'

describe "admin/editions/edit" do
  before(:each) do
    @admin_edition = assign(:admin_edition, stub_model(Admin::Edition))
  end

  it "renders the edit admin_edition form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", admin_edition_path(@admin_edition), "post" do
    end
  end
end
