class Project < ActiveRecord::Base
  attr_accessible :amount_to_raise, :capital_type, :category, :city, :close_timeline, :description, :loan_to_value, :name, :partners, :state, :status, :user_id
  
  belongs_to :user
  
  CATEGORIES = ["Single Family For Sale", "Single Family For Lease", "Duplex", "Multifamily", "Apartment Complex", "Land", "Retail", "Office", "Restaurant", "Lodging / Resort", "Other"]
  AMOUNT_TO_RAISE = ["50-250K", "250K-$1M", "$1-5M", ">$5M"]
  CAPTIAL_TYPE =  ["Debt",  "Equity", "Both"]
  LOAN_TO_VALUE = ["60%","70%","80%","90%"]
  CLOSE_TIMELINE = ["<30 days", "30-60 days", "60-90 days", "90-120 days", ">120 days", "Flexible / Doesn\'t Matter"]
  
  
end
