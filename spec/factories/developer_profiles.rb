# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :developer_profile do
    user_id 1
    phone_number "MyString"
    total_debt_plus_equity "MyString"
    experience "MyString"
    employment "MyString"
    yearly_projects "MyString"
    how_did_you_hear "MyString"
    how_response "MyString"
    why "MyString"
  end
end
