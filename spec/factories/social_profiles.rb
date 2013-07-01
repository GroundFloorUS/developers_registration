# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :social_profile do
    user_id 1
    identity_id 1
    provider "MyString"
    followers 1
    friends 1
    name "MyString"
    location "MyString"
    description "MyString"
    username "MyString"
    message_count 1
    gender "MyString"
    provider_id "MyString"
    link "MyString"
    profile_image "MyString"
    industry "MyString"
  end
end
