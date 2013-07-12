class Groundfloor::SessionsController < Devise::SessionsController
  prepend_before_filter :require_no_authentication, :only => [ :new, :create ]
  prepend_before_filter :allow_params_authentication!, :only => :create
  prepend_before_filter { request.env["devise.skip_timeout"] = true }
  
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    
    logger.debug("Current User: #{current_user.id} => Resource: #{resource.id}")
    
    session[:registration] = Registration.new(user_id: current_user.id, 
          name: current_user.name, 
          first_name: current_user.first_name, 
          last_name: current_user.last_name, 
          developer_profile_id: (current_user.developer_profile.present? ? current_user.developer_profile.id : nil), 
          has_projects: (current_user.projects.length > 0 ? true : false), 
          completed: current_user.registration_completed)
    respond_with resource, :location => after_sign_in_path_for(resource)
  end
  
  def destroy
    redirect_path = after_sign_out_path_for(resource_name)
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message :notice, :signed_out if signed_out && is_navigational_format?

    # We actually need to hardcode this as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|
      format.all { head :no_content }
      format.any(*navigational_formats) { redirect_to root_path(:signed_out => "t") }
    end
  end
   
   def auth_callback
     auth = request.env['omniauth.auth']

     # Find an identity here
     @identity = Identity.find_with_omniauth(auth)

     if @identity.nil?
       # If no identity was found, create a brand new one here
       @identity = Identity.create_with_omniauth(auth)
     end

     @profile = SocialProfile.find_by_identity_id(@identity.id)
     if signed_in?
       if @identity.user != current_user
         # The identity is not associated with the current_user so lets 
         # associate the identity
         @identity.user = current_user
         @identity.save()
       end
       session[:registration] = Registration.new(identity_id: @identity.id, user_id: current_user.id, social_profile_id: @profile.id, name: @profile.name, first_name: current_user.first_name, last_name: current_user.last_name, developer_profile_id: (current_user.developer_profile ? current_user.developer_profile.id : nil), has_projects: (current_user.projects.length > 0 ? true : false), completed: current_user.registration_completed)
       sign_in(current_user)
       redirect_to current_user.registation_url
     else
       if @identity.user.present?
         # The identity we found had a user associated with it so let's 
         # just log them in here
         @user = @identity.user
         session[:registration] = Registration.new(identity_id: @identity.id, user_id: @user.id, social_profile_id: @profile.id, name: @profile.name, first_name: @user.first_name, last_name: @user.last_name, developer_profile_id: (@user.developer_profile ? @user.developer_profile.id : nil), has_projects: (@user.projects.length > 0 ? true : false), completed: @user.registration_completed)
         sign_in(@user)
         redirect_to @user.registation_url, notice: "Please finish registering"
       else

         #social_profile user_id:integer type:string followers:integer friends:integer name:string location:string description:string username:string message_count:integer
         unless @profile
           case auth.provider
           when "twitter"
             @profile = SocialProfile.new(provider: "twitter", 
                 identity_id: @identity.id,
                 followers: auth.extra.raw_info.followers_count || 0,
                 friends: auth.extra.raw_info.friends_count || 0,
                 name: auth.info.name || "",
                 location: auth.extra.raw_info.location || "",
                 description: auth.info.description || "",
                 username: auth.info.nickname || "",
                 message_count: auth.extra.raw_info.statuses_count || 0,
                 provider_id: auth.extra.raw_info.id || "",
                 profile_image: auth.extra.raw_info.profile_image_url_https || "")
           when "linkedin"
             @user = User.find_by_email(auth.extra.raw_info.emailAddress)
             @profile = SocialProfile.new(provider: "linkedin", 
                 identity_id: @identity.id,
                 name: "#{auth.extra.raw_info.firstName} #{auth.extra.raw_info.lastName}" || "",
                 location: auth.extra.raw_info.location.name || "",
                 description: auth.extra.raw_info.headline || "",
                 username: auth.info.nickname || "",
                 provider_id: auth.extra.raw_info.id || "",
                 link: auth.extra.raw_info.publicProfileUrl || "",
                 industry: auth.extra.raw_info.industry || "")
           when "facebook"
             @user = User.find_by_email(auth.info.email)
             @profile = SocialProfile.new(provider: "facebook", 
                 identity_id: @identity.id,
                 name: "#{auth.info.first_name} #{auth.info.last_name}" || "",
                 location: auth.info.location || "",
                 username: auth.info.nickname || "",
                 gender: auth.extra.raw_info.gender || "",
                 provider_id: auth.extra.raw_info.id || "",
                 link: auth.extra.raw_info.link || "",
                 profile_image: auth.info.image || "")
           end 

           if @user
             @user.save! if @user.changed?
             @identity.user = @user
             @identity.save()
           end
           @profile.user = @identity.user if @identity.user
           @profile.save
         end

         if @user 
           if @user.registation_url
             session[:registration] = Registration.new(identity_id: @identity.id, user_id: @user.id, social_profile_id: @profile.id, name: @user.name, first_name: @user.first_name, last_name: @user.last_name, has_projects: false)
             redirect_to @user.registation_url, notice: "Please finish registering"
           else
             sign_in_and_redirect(:user, @identity.user)
           end
         else
           session[:registration] = Registration.new(identity_id: @identity.id, social_profile_id: @profile.id, name: @profile.name, has_projects: false)
           redirect_to account_path
         end

         # if @identity.user
         #   #  User already exists so add this to the profile and then sign in
         #   logger.debug("user found so log them in")
         #   sign_in_and_redirect(:user, @user)
         # else
         #   session[:registration] = Registration.new(identity_id: @identity.id, social_profile_id: @profile.id, first_name: @profile.first_name, last_name: @profile.last_name, state: :started)
         #   redirect_to account_url, notice: "Please finish registering"
         # end
       end
     end
   end

end