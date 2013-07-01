class InvestmentsController < InheritedResources::Base
  
  before_filter :authenticate_user!

  def create
    @investment = Investment.new(params[:investment].merge({prospected_price: 100, prospected_at: DateTime.now }))
    create!(:notice => "Your investment has been saved.") { root_url }  
  end
  
end
