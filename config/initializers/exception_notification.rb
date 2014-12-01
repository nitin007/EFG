unless Rails.env.development? or Rails.env.test?
  Rails.application.config.middleware.use ExceptionNotifier,
    :email_prefix => "[#{Rails.application.to_s.split('::').first}][#{ENV['EFG_ENVIRONMENT']}]",
    :sender_address => ENV['EFG_MAIL_FROM_ADDRESS'],
    :exception_recipients => [ENV['EFG_EXCEPTION_MAILER_TO_ADDRESS']]
end
