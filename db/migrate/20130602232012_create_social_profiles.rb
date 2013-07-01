class CreateSocialProfiles < ActiveRecord::Migration
  def change
    create_table :social_profiles do |t|
      t.integer :user_id
      t.integer :identity_id
      t.string :provider
      t.integer :followers
      t.integer :friends
      t.string :name
      t.string :location
      t.string :description
      t.string :username
      t.integer :message_count
      t.string :gender
      t.string :provider_id
      t.string :link
      t.string :profile_image
      t.string :industry

      t.timestamps
    end
    
    add_index :social_profiles, :user_id
    
  end
end
