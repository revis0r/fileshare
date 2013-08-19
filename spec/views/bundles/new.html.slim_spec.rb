require 'spec_helper'

describe "bundles/new" do
  before(:each) do
    assign(:bundle, stub_model(Bundle,
      :state => "MyString",
      :possible_downloads => 1,
      :destroy_code => "MyString",
      :zip_archive => "MyString",
      :text => "MyText",
      :code => "MyString"
    ).as_new_record)
  end

  it "renders new bundle form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", bundles_path, "post" do
      assert_select "input#bundle_state[name=?]", "bundle[state]"
      assert_select "input#bundle_possible_downloads[name=?]", "bundle[possible_downloads]"
      assert_select "input#bundle_destroy_code[name=?]", "bundle[destroy_code]"
      assert_select "input#bundle_zip_archive[name=?]", "bundle[zip_archive]"
      assert_select "textarea#bundle_text[name=?]", "bundle[text]"
      assert_select "input#bundle_code[name=?]", "bundle[code]"
    end
  end
end
