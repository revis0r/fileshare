require 'spec_helper'

describe "slots/index" do
  before(:each) do
    assign(:slots, [
      stub_model(Slot,
        :possible_downloads => 1,
        :state => "State",
        :size => 2,
        :file => "File"
      ),
      stub_model(Slot,
        :possible_downloads => 1,
        :state => "State",
        :size => 2,
        :file => "File"
      )
    ])
  end

  it "renders a list of slots" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "State".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "File".to_s, :count => 2
  end
end
