require 'spec_helper'

describe "investments/edit" do
  before(:each) do
    @investment = assign(:investment, stub_model(Investment,
      :user_id => 1,
      :prospect_quantity => 1,
      :prospected_price => 1,
      :commited_quantity => 1,
      :commited_price => 1
    ))
  end

  it "renders the edit investment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", investment_path(@investment), "post" do
      assert_select "input#investment_user_id[name=?]", "investment[user_id]"
      assert_select "input#investment_prospect_quantity[name=?]", "investment[prospect_quantity]"
      assert_select "input#investment_prospected_price[name=?]", "investment[prospected_price]"
      assert_select "input#investment_commited_quantity[name=?]", "investment[commited_quantity]"
      assert_select "input#investment_commited_price[name=?]", "investment[commited_price]"
    end
  end
end
