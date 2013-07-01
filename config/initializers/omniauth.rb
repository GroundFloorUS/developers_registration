Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, Figaro.env.TWITTER_KEY, Figaro.env.TWITTER_SECRET
  provider :linkedin, Figaro.env.LINKEDIN_KEY, Figaro.env.LINKEDIN_SECRET
  provider :facebook, Figaro.env.FACEBOOK_KEY, Figaro.env.FACEBOOK_SECRET
end