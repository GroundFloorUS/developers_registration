# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :roles_user, :class => 'RolesUsers' do
    user_id 1
    role_id 1
  end
end
