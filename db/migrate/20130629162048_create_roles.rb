class CreateRoles < ActiveRecord::Migration
  def down
    drop_table :roles
  end
  
  def up
    create_table :roles do |t|
      t.string :name
      t.timestamps
    end
    
    add_index :roles, :name, :unique => true    
    
    Role.create(name: Role::INVESTOR)
    Role.create(name: Role::DEVELOPER)
  end
end
