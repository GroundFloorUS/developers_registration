ActiveAdmin.register Project do

  filter :name
  filter :city
  filter :state
  filter :amount_to_raise
  filter :close_timeline
  filter :loan_to_value
  filter :capital_type
  filter :category
  
  index do
    selectable_column
    column "Name" do |project|
      link_to project.name, admin_project_path(project)
    end
    column "Developer" do |project|
      link_to project.user.name, admin_user_path(project.user)
    end
    column "Ask Amount" do |project|
      project.amount_to_raise.present? ? number_to_currency(project.amount_to_raise) : "$0"
    end
    column "Closing" do |project|
      project.close_timeline.present? ? project.close_timeline : "N/A"
    end
    column "Ask Amount" do |project|
      project.amount_to_raise.present? ? number_to_currency(project.amount_to_raise) : "$0"
    end
    column "Loan To Debt" do |project|
      project.close_timeline.present? ? project.close_timeline : "N/A"
    end
    column "Capital" do |project|
      project.capital_type.present? ? project.capital_type : "N/A"
    end
    column "Category" do |project|
      project.category.present? ? project.category : "N/A"
    end
  end
  
  show :title => :name do |project|
    columns do
      column do
        attributes_table do
          row :name do |project| 
            project.name ? project.name : "No Name Entered" 
          end
          row :city
          row :state
          row :amount_to_raise do |project| 
            project.amount_to_raise.present? ? number_to_currency(project.amount_to_raise) : "$0"
          end
          row :close_timeline do |project| 
            project.close_timeline.present? ? project.close_timeline : "N/A" 
          end
          row :loan_to_value do |project| 
            project.loan_to_value.present? ? project.loan_to_value : "N/A"
          end
          row :capital_type do |project| 
            project.capital_type.present? ? project.capital_type : "N/A" 
          end
          row :category do |project| 
            project.category.present? ? project.category : "N/A" 
          end
          row :status do |project| 
            project.status.present? ? project.status : "N/A"
          end
          row :description do |project| 
            project.description.present? ? project.description : "N/A"
          end
        end
      end

      column do
        panel "Developer" do
          attributes_table_for project.user do
            row :name do |user|
              user.name.present? ? link_to(user.name, admin_user_path) : "N/A" 
            end
            row :email
            row :sign_in_count
            row :current_sign_in_at
            row :last_sign_in_at
          end
        end
        
        if project.user.developer_profile
          panel "Developer Profile" do
            attributes_table_for project.user.developer_profile do 
              row :phone_number
              row :employment
              row :experience
              row :total_debt_plus_equity
              row :yearly_projects
              row :how_did_you_hear
              row :how_response
              row :why
            end
          end
        end
      end
    end
    
    @other_projects = Project.where{ user_id == "#{project.user_id}" }.where{ id != "#{project.id}" }
    if @other_projects.length > 0
      panel "Other Projects By This Developer" do
        table_for @other_projects do |t|
          t.column("Name") { |project| project.name ? link_to(project.name, admin_project_path(project)) : "No Name Entered" }
          t.column("Ask Amount") { |project| project.amount_to_raise.present? ? number_to_currency(project.amount_to_raise) : "$0" }
          t.column("Close Timeline") { |project| project.close_timeline.present? ? project.close_timeline : "N/A" }
          t.column("Loan To Debt") { |project| project.loan_to_value.present? ? project.loan_to_value : "N/A" }
          t.column("Capital Type") { |project| project.capital_type.present? ? project.capital_type : "N/A" }
          t.column("Category") { |project| project.category.present? ? project.category : "N/A" }
        end
      end
    end
    
    active_admin_comments
  end
  
  
end
