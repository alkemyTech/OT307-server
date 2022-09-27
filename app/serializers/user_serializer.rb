# frozen_string_literal: true

class UserSerializer
  include JSONAPI::Serializer
  attributes :first_name, :last_name, :email
  # attributes user_photo do |user|
  #   user.photo.service_url if user.photo.attached?
  # end
end
