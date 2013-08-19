require 'spec_helper'

describe "bundles/show" do
  before(:each) do
    @bundle = assign(:bundle, stub_model(Bundle,
      :state => "State",
      :possible_downloads => 1,
      :destroy_code => "Destroy Code",
      :zip_archive => "Zip Archive",
      :text => "MyText",
      :code => "Code"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/State/)
    rendered.should match(/1/)
    rendered.should match(/Destroy Code/)
    rendered.should match(/Zip Archive/)
    rendered.should match(/MyText/)
    rendered.should match(/Code/)
  end
end
