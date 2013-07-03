class RegistrationsController < ApplicationController
  before_filter :set_registration
  before_filter :authenticate_user!, :except => [:create_account]
  
  def set_registration
    @path = request.fullpath.split("?").first
    @registration = session[:registration]
    logger.debug("Registration: #{@registration.inspect}")
  end
  
  def account
    # Check to see if we came from a social profile or if this is a new account
    if @registration && @registration.identity_id
      @identity = Identity.find(@registration.identity_id) 
    else 
      @registration = Registration.new
    end
    
    session[:registration] = @registration
    @user = @registration.user_id ? User.find(@registration.user_id) : User.new(name: @registration.name, first_name: @registration.name.split(" ").first)
  end
  
  def create_account
    user = User.create(params[:user].merge(password_confirmation: params[:user][:password]))
    sign_in(user)
    session[:registration] = Registration.new(user_id: user.id, name: user.name, first_name: user.first_name, last_name: user.last_name, has_projects: false, completed: false)
    redirect_to profile_path
  end

  def profile
    temp_password = SecureRandom.hex(10)
    
    if @registration && @registration.user_id
      @user = User.find(@registration.user_id) 
    else
      # if the email exists redirect to the login page.  If the user doesn't exist then create them
      @user = User.find_by_email(params[:user][:email]) || User.create(params[:user].merge(password_confirmation: params[:user][:password]))
    end
    
    if params[:user]
      User.transaction do 
        @social_profile = SocialProfile.find(@registration.social_profile_id) if @registration.social_profile_id
        
        params[:user].each do |key, value|
          @user.send("#{key}=".to_sym, value) if @user.attributes.has_key? key
        end 

        if @social_profile.profile_image
          @user.avatar_url = @social_profile.profile_image
        else
          @user.avatar_url = Gravatar.new(@user.email).image_url 
        end if @user.avatar_url.blank?

        if @user.new_record?
          @user.password = temp_password
          @user.password_confirmation = temp_password
        end
        @user.save! if @user.changed?
        
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
    sign_in(@user) if @user
  end
  
  def projects
    logger.debug("Step: #{@registration.step}")
    if params[:developer_profile]
      @profile = @registration.developer_profile_id ? DeveloperProfile.find(@registration.developer_profile_id) : DeveloperProfile.new(user_id: @registration.user_id)
      logger.debug("Developer Profile: #{@profile.inspect}")
      @profile.transaction do
        params[:developer_profile].each do |key, value|
          @profile.send("#{key}=".to_sym, value) if @profile.attributes.has_key? key
        end
        @profile.save
        @registration.developer_profile_id = @profile.id unless @registration.developer_profile_id
      end
    end

    if params[:project]
      @project = Project.find_by_user_id_and_id(current_user.id, params[:project][:id]) || Project.new(user_id: current_user.id)
      @project.transaction do
        params[:project].each do |key, value|
          @project.send("#{key}=".to_sym, value) if @project.attributes.has_key? key
        end
        @project.save
      end
      @registration.has_projects = true
    end  
      
    session[:registration] = @registration
    @project = Project.find_by_user_id_and_id(current_user.id, params[:id]) || Project.new(user_id: current_user.id) unless @project
    @projects = current_user.projects
  end
  
  def delete_project
    project = Project.find_by_user_id_and_id(current_user.id, params[:id])
    project.destroy if project
    
    @project = Project.new(user_id: current_user.id)
    @projects = current_user.projects
    render :action => :projects
  end
  
  def thanks
    current_user.update_attribute(:registration_completed, true) unless current_user.registration_completed
    @registration.completed = true
    session[:registration] = @registration

    @projects = current_user.projects
  end

end
