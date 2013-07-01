class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :user_id
      t.string :name
      t.string :category
      t.string :amount_to_raise
      t.string :capital_type
      t.string :loan_to_value
      t.string :close_timeline
      t.integer :partners
      t.string :city
      t.string :state
      t.string :status
      t.string :description

      t.timestamps
    end
  end
end
