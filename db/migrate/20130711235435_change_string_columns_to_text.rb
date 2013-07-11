class ChangeStringColumnsToText < ActiveRecord::Migration
  def self.up
    change_column :developer_profiles, :why, :text
    change_column :projects, :status, :text
    change_column :projects, :description, :text
  end

  def self.down
   change_column :developer_profiles, :why, :string
   change_column :projects, :status, :string
   change_column :projects, :description, :string
  end
end
