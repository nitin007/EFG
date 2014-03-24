unless Rails.env.development? or Rails.env.test?
  Rails.application.config.middleware.use ExceptionNotification::Rack,
    :email_prefix => "[#{Rails.application.to_s.split('::').first}] (#{Plek.current.environment})",
    :sender_address => %{"Winston Smith-Churchill" <winston@alphagov.co.uk>},
    :exception_recipients => %w{govuk-exceptions@digital.cabinet-office.gov.uk}
end
