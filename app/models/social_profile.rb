class SocialProfile < ActiveRecord::Base
  attr_accessible :description, :followers, :friends, :gender, :identity_id, :industry, :link, :location, :message_count, :name, :profile_image, :provider, :provider_id, :user_id, :username

  belongs_to :user
  belongs_to :identity

  def first_name
    self.name.split(" ").first
  end

  def last_name
    self.name.split(" ").last
  end

end
