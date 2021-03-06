class CreateRolesUsers < ActiveRecord::Migration
  def up
    create_table :roles_users do |t|
      t.integer :user_id
      t.integer :role_id
      t.timestamps
    end
    
    add_index :roles_users, :user_id
    add_index :roles_users, :role_id
  end
  
  def down
    drop_table :roles_users
  end
end
