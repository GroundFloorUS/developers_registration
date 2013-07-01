class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :first_name, :last_name, :email, :password, :password_confirmation, :remember_me, 
                  :referral_code, :avatar_url, :registration_completed

  has_many :addresses, :as => :addressable
  has_many :social_profiles, :dependent => :destroy
  has_many :projects, :dependent => :destroy
  has_one :developer_profile, :dependent => :destroy
  has_and_belongs_to_many :roles
  
  before_create :split_name, :create_referral_code
  
  def split_name
    if !self.name.nil? && self.first_name.nil? && self.last_name.nil?
      self.first_name = self.name.split(" ").first
      self.last_name = self.name.split(" ").last
    end
  end
  
  def title
    self.first_name || self.name
  end
  
  def create_referral_code
    begin
      referral_code = SecureRandom.hex(4)
    end while User.where(:referral_code => referral_code).exists?
    self.referral_code = referral_code
  end
  
  def self.add_referral_points(referral_code)
    lead = self.find_by_referral_code(referral_code)
    lead.update_attribute(:referral_points, lead.referral_points + 1) if lead
  end

  def registation_url
    self.developer_profile.nil? ? Rails.application.routes.url_helpers.profile_path : Rails.application.routes.url_helpers.projects_path
  end
  
  def has_role?(role=nil)
    self.roles.where(name: role).first
  end
  
end
