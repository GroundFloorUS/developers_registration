require 'spec_helper'

describe "investments/index" do
  before(:each) do
    assign(:investments, [
      stub_model(Investment,
        :user_id => 1,
        :prospect_quantity => 2,
        :prospected_price => 3,
        :commited_quantity => 4,
        :commited_price => 5
      ),
      stub_model(Investment,
        :user_id => 1,
        :prospect_quantity => 2,
        :prospected_price => 3,
        :commited_quantity => 4,
        :commited_price => 5
      )
    ])
  end

  it "renders a list of investments" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
  end
end
