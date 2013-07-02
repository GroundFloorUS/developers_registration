ActionMailer::Base.add_delivery_method :ses, AWS::SES::Base,
  :access_key_id     => Figaro.env.AWS_KEY,
  :secret_access_key => Figaro.env.AWS_SECRET

