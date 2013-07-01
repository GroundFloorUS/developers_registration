require 'spec_helper'

describe "investments/show" do
  before(:each) do
    @investment = assign(:investment, stub_model(Investment,
      :user_id => 1,
      :prospect_quantity => 2,
      :prospected_price => 3,
      :commited_quantity => 4,
      :commited_price => 5
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/4/)
    rendered.should match(/5/)
  end
end
