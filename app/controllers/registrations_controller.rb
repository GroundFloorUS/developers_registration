class RegistrationsController < ApplicationController
  before_filter :set_registration
  before_filter :authenticate_user!, :except => [:index, :account, :create_account, :profile]
  
  def set_registration
    @path = request.fullpath.split("?").first
    @registration = session[:registration]
    logger.debug("Registration: #{@registration.inspect}")
  end
  
  def index
    
  end
  
  def account
    if @registration
      @user = current_user || User.new(name: @registration.name)
      @registration = Registration.new(user_id: current_user.id, name: current_user.name, first_name: current_user.first_name, last_name: current_user.last_name, has_projects: (current_user.projects.length > 0 ? true : false), completed: current_user.registration_completed) unless @registration 
      session[:registration] = @registration
    else
      # if there is no registration someone came directly to this page so redirect them to the root
      redirect_to root_path
    end
  end
  
  def create_account
    @user = User.new(params[:user].merge(password_confirmation: params[:user][:password]))
    if @user.save
      sign_in(@user)
      session[:registration] = Registration.new(user_id: @user.id, name: @user.name, first_name: @user.first_name, last_name: @user.last_name, has_projects: false, completed: false)
      redirect_to profile_path
    else
      flash[:error] = "Your user was not created, please address the form errors listed below and try again: <span>#{@user.errors.full_messages.join('<br>')}</span>"
      logger.error("Errors Saving User: #{@user.errors.full_messages}")
      redirect_to root_path
    end
  end

  def profile
    if @registration
      if params[:user].present?
        temp_password = SecureRandom.hex(10)
        @user = (params[:user][:id].present? ? current_user : User.create(params[:user].merge(password_confirmation: params[:user][:password])) )
        logger.debug("User: #{@user.inspect}")
        User.transaction do 
          @social_profile = SocialProfile.find(@registration.social_profile_id) if @registration.social_profile_id
        
          params[:user].each do |key, value|
            @user.send("#{key}=".to_sym, value) if @user.attributes.has_key? key
          end 

          if @social_profile && @social_profile.profile_image
            @user.avatar_url = @social_profile.profile_image
          else
            @user.avatar_url = Gravatar.new(@user.email).image_url 
          end if @user.avatar_url.blank?

          if @user.new_record?
            #flash.now[:info] = "<b>Your off to a great start.</b> Your account has been created"
            @user.password = temp_password
            @user.password_confirmation = temp_password
          end
          if @user.changed? && @user.save!
            #flash.now[:info] = (current_user.present? ? "<b>Your off to a great start.</b> Your account has been created" : "<b>Thanks</b>  Your account has been updated.")
          end
        
          # sign in the new user unless he is already signed in
          sign_in(@user) unless current_user
        
          @social_profile.update_attribute(:user_id, @user.id) if @social_profile && @user.id 
          @identity = ((@registration && @registration.identity_id) ? Identity.find(@registration.identity_id) : Identity.create(provider: "groundfloor"))
          @identity.update_attribute(:user_id,  @user.id)

          @registration.user_id = @user.id
      
          # verify that the registration has the idenity or set it if it is not ther
          @registration.identity_id = @identity.id unless @registration.identity_id
        
          RolesUsers.create(user_id: @registration.user_id, role_id: Role.find_by_name(Role::DEVELOPER).id) 
        end
      end

      @profile = @registration.developer_profile_id ? DeveloperProfile.find(@registration.developer_profile_id) : DeveloperProfile.new(user_id: @registration.user_id)
      session[:registration] = @registration
    else
      # if there is no registration someone came directly to this page so redirect them to the root
      redirect_to root_path
    end
  end
  
  def projects
    logger.debug("Step: #{@registration.step}")
    saved = false
    
    if params[:developer_profile].present?
      @profile = @registration.developer_profile_id ? DeveloperProfile.find(@registration.developer_profile_id) : DeveloperProfile.new(user_id: @registration.user_id)
      @profile.transaction do
        params[:developer_profile].each do |key, value|
          @profile.send("#{key}=".to_sym, value) if @profile.attributes.has_key? key
        end
        if @profile.changed? && @profile.save
          #flash.now[:info] = (params[:developer_profile][:id].nil? ? "<b>Great News!</b>  Your profile has been created." : "<b>Thanks</b>  Your profile has been updated.")
        end
        @registration.developer_profile_id = @profile.id unless @registration.developer_profile_id
      end
    end

    if params[:project].present?
      @project = Project.find_by_user_id_and_id(current_user.id, params[:project][:id]) || Project.new(user_id: current_user.id)
      @project.transaction do
        params[:project].each do |key, value|
          @project.send("#{key}=".to_sym, value) if @project.attributes.has_key? key
        end

        logger.debug("SAVING PROEJCT")
        if @project.save
          saved = true
        else 
          flash.now[:error] = "Your project was not created. Please address the errors listed below and try again: <span>#{@project.errors.full_messages.join('<br>')}</span>"
        end
        
      end
      @registration.has_projects = true
    end  
    
    session[:registration] = @registration
    @projects = current_user.projects

    # Now redirect to thanks since this was a post and we are done with the project
    if saved
      if params[:add_another].present? 
        logger.debug("Adding Another Project")
        @project = Project.new(user_id: current_user.id) 
      else
        if params[:project] && params[:project][:id].present?
          flash[:notice] = "<b>Thanks.</b>  Your project has been successfully updated."
        else
          flash[:notice] = "<b>Nice work!</b> Your project has been successfully created. Click in the blue box to edit, delete, or add another."
        end
        redirect_to :thanks if params[:project].present?
      end
    end
    logger.debug("Last Errors: #{flash.inspect} ")
    @project = Project.find_by_user_id_and_id(current_user.id, params[:id]) || Project.new(user_id: current_user.id) unless @project
  end
  
  def delete_project
    project = Project.find_by_user_id_and_id(current_user.id, params[:id])
    if project && project.destroy 
      flash[:notice] = "<b>Confirmed.</b> Your project has been removed."
    end
    
    @project = Project.new(user_id: current_user.id)
    @projects = current_user.projects
    if @projects.length > 0
      redirect_to :thanks
    else
      render :action => :projects
    end
  end
  
  def thanks
    current_user.update_attribute(:registration_completed, true) unless current_user.registration_completed
    @registration.completed = true
    session[:registration] = @registration

    @projects = current_user.projects
  end

end
