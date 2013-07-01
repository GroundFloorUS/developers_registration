class Registration 
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
    
  attr_accessor :identity_id, :name, :first_name, :last_name, :email, :social_profile_id, :address_id, :developer_profile_id, :has_projects, 
                :user_id, :role, :continue_url, :completed
  
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  
  def initialize(attributes = {})
    options = {
      :completed => false,
      :has_projects => false
    }.merge(attributes)
    
    options.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def step
    return 1 if self.user_id.nil?
    return 2 if self.user_id && self.developer_profile_id.nil?
    return 3 if self.developer_profile_id && !self.has_projects
    return 4 if self.has_projects && !completed
    return 5 if self.completed
  end
  
  def persisted?
    false
  end
  
end