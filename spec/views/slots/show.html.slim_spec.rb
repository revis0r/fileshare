require 'spec_helper'

describe "slots/show" do
  before(:each) do
    @slot = assign(:slot, stub_model(Slot,
      :possible_downloads => 1,
      :state => "State",
      :size => 2,
      :file => "File"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/State/)
    rendered.should match(/2/)
    rendered.should match(/File/)
  end
end
