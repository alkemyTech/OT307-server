# frozen_string_literal: true

class UserNotifierMailer < ApplicationMailer
  default { :from => '' }

  def send_welcome_email(user, subject)
    @destinatary = user
    @subject = subject
    mail(to: @destinatary.email, subject: @subject)
  end
end
