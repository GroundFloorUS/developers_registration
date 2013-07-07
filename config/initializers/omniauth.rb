Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, Figaro.env.TWITTER_KEY, Figaro.env.TWITTER_SECRET
  #provider :linkedin, Figaro.env.LINKEDIN_KEY, Figaro.env.LINKEDIN_SECRET, :scope => 'r_fullprofile r_emailaddress r_network', :fields => ["id", "email-address", "first-name", "last-name", "headline", "industry", "picture-url", "public-profile-url", "location", "connections"]
  provider :linkedin, Figaro.env.LINKEDIN_KEY, Figaro.env.LINKEDIN_SECRET
  provider :facebook, Figaro.env.FACEBOOK_KEY, Figaro.env.FACEBOOK_SECRET, :scope => 'email,user_birthday', :display => 'popup'
end