require 'spec_helper'

describe "slots/edit" do
  before(:each) do
    @slot = assign(:slot, stub_model(Slot,
      :possible_downloads => 1,
      :state => "MyString",
      :size => 1,
      :file => "MyString"
    ))
  end

  it "renders the edit slot form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", slot_path(@slot), "post" do
      assert_select "input#slot_possible_downloads[name=?]", "slot[possible_downloads]"
      assert_select "input#slot_state[name=?]", "slot[state]"
      assert_select "input#slot_size[name=?]", "slot[size]"
      assert_select "input#slot_file[name=?]", "slot[file]"
    end
  end
end
