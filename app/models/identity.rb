class Identity < ActiveRecord::Base
  attr_accessible :provider, :uid, :user_id

  belongs_to :user
  has_many :social_profiles
  
  def self.find_with_omniauth(auth)
    find_by_provider_and_uid(auth['provider'], auth['uid'])
  end

  def self.create_with_omniauth(auth)
    create(uid: auth['uid'], provider: auth['provider'])
  end

end
