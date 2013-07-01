class AddAvatarToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :referral_code, :string
    add_column :users, :avatar_url, :string
    add_column :users, :registration_completed, :boolean, :default => false
  end
end
