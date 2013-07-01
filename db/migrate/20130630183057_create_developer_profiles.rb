class CreateDeveloperProfiles < ActiveRecord::Migration
  def change
    create_table :developer_profiles do |t|
      t.integer :user_id
      t.string :phone_number
      t.string :total_debt_plus_equity
      t.string :experience
      t.string :employment
      t.string :yearly_projects
      t.string :how_did_you_hear
      t.string :how_response
      t.string :why

      t.timestamps
    end
  end
end
