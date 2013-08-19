require 'spec_helper'

describe "bundles/index" do
  before(:each) do
    assign(:bundles, [
      stub_model(Bundle,
        :state => "State",
        :possible_downloads => 1,
        :destroy_code => "Destroy Code",
        :zip_archive => "Zip Archive",
        :text => "MyText",
        :code => "Code"
      ),
      stub_model(Bundle,
        :state => "State",
        :possible_downloads => 1,
        :destroy_code => "Destroy Code",
        :zip_archive => "Zip Archive",
        :text => "MyText",
        :code => "Code"
      )
    ])
  end

  it "renders a list of bundles" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "State".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Destroy Code".to_s, :count => 2
    assert_select "tr>td", :text => "Zip Archive".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Code".to_s, :count => 2
  end
end
