# frozen_string_literal: true

class UserNotifierMailer < ApplicationMailer
  default { :from => '' }

  def send_welcome_email(params)
    @email = params[:to]
    @subject = params[:subject]
    mail(to: @email, subject: @subject)
  end
end
