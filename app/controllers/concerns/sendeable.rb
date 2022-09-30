# frozen_string_literal: true

module Sendeable
  extend ActiveSupport::Concern

  def self.send_welcome_email(user, subject)
    UserNotifierMailer.send_welcome_email(user, subject).deliver
  end
end
