ActionMailer::Base.smtp_settings = {
    :address              => "smtp.sendgrid.net",
    :port                 => 587,
    :domain               => "dixieoutfitters.com",
    :user_name            => "dixieoutfitters",
    :password             => "SendSafe55",
    :authentication       => "plain",
    :enable_starttls_auto => true
}

#ActionMailer::Base.default_url_options[:host] = "localhost:3000"
#Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?