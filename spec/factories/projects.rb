# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
    user_id 1
    name "MyString"
    category "MyString"
    amount_to_raise "MyString"
    capital_type "MyString"
    loan_to_value "MyString"
    close_timeline "MyString"
    partners 1
    city "MyString"
    state "MyString"
    status "MyString"
    description "MyString"
  end
end
