class UserMailer < ActionMailer::Base

  default :from => Devise.mailer_sender

  def new_account_notification(user, token)
    @user = user
    @token = token
    mail(to: user.email, subject: "Please login to your new EFG account")
  end

end
