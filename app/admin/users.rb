ActiveAdmin.register User do

  filter :email
  filter :first_name
  filter :last_name
  filter :sign_in_count
  filter :last_sign_in
  
  scope :active do |tasks|
    User.where("sign_in_count > ?", 0)
  end

  index do
    selectable_column
    column "Name" do |user|
      link_to user.name, admin_user_path(user)
    end
    column :email
    column "Number Of Projects" do |user|
      user.projects.count
    end
    column :sign_in_count
    column :current_sign_in_at
    column :last_sign_in_at
  end
  
  show :title => :admin_title do |user|
    columns do
      column do
        attributes_table do
          row :name
          row :email
          row :sign_in_count
          row :current_sign_in_at
          row :last_sign_in_at
          row :current_sign_in_ip
          row :last_sign_in_ip
        end
      end

      column do
        if user.developer_profile
          panel "Developer Profile" do
            attributes_table_for user.developer_profile do 
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
    
    if user.social_profiles.count > 0
      @profiles = user.social_profiles.all
      panel "Social Profiles" do
        table_for @profiles do |t|
          t.column("Provider") { |profile| profile.link ? link_to(profile.provider, profile.link) : profile.provider }
          t.column("Name") { |profile| profile.name.present? ? profile.name : "N/A"}
          t.column("Username") { |profile| profile.username.present? ? profile.username : "N/A"}
          t.column("Gender") { |profile| profile.gender.present? ? profile.gender : "N/A"}
          t.column("Location") { |profile| profile.location.present? ? profile.location : "N/A"}
          t.column("Industry") { |profile| profile.industry.present? ? profile.industry : "N/A"}
          t.column("Description") { |profile| profile.description ? profile.description : "N/A"}
          t.column("Followers") { |profile| profile.followers > 0 ? number_with_delimiter(profile.followers) : "0" }
          t.column("Friends") { |profile| profile.friends > 0 ? number_with_delimiter(profile.friends) : "0" }
          t.column("Messages") { |profile| profile.message_count > 0 ? number_with_delimiter(profile.message_count) : "0" }
        end
      end
    end
    
    if user.projects.count > 0
      @projects = user.projects.order(:created_at).all
      panel "Projects" do
        table_for @projects do |t|
          t.column("Name") { |project| project.name ? link_to(project.name, admin_project_path(project)) : "No Name Entered" }
          t.column("Ask Amount") { |project| project.amount_to_raise.present? ? number_to_currency(project.amount_to_raise) : "$0" }
          t.column("Close Timeline") { |project| project.close_timeline.present? ? project.close_timeline : "N/A" }
          t.column("Loan To Debt") { |project| project.loan_to_value.present? ? project.loan_to_value : "N/A" }
          t.column("Capital Type") { |project| project.capital_type.present? ? project.capital_type : "N/A" }
          t.column("Category") { |project| project.category.present? ? project.category : "N/A" }
          t.column("Partners Involved") { |project| project.partners.present? ? project.partners : "N/A" }
        end
      end
    end
  end
  
  form do |f|
    f.inputs "User" do
      f.input :email
      f.input :name
      f.input :first_name
      f.input :last_name
    end

    f.actions
  end
end
