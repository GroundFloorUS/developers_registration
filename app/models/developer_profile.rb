class DeveloperProfile < ActiveRecord::Base
  attr_accessible :employment, :experience, :how_did_you_hear, :how_response, :phone_number, :total_debt_plus_equity, :user_id, :why, :yearly_projects

  belongs_to :user
  
  DEBT_EQUITY = ["$50-250K", "$250-500K", "$500k-$1M", "$1-5M", "$5-10M", "$10-50M", ">$50M"]
  EXPERIENCE = ["0-5 years", "5-10", "10-20", ">20"]
  EMPLOYMENT = ["Part Time", "Full Time"]
  PROJECTS_PER_YEAR = ["0-5", "5-10", "10-20", "20+"]
  WHERE_DID_YOU_HEAR =  ["Web Search", "Facebook", "LinkedIn", "Twitter", "News Article", "Online Discussion Board", "Trade Association", "Friend / Associate"]
  
end
