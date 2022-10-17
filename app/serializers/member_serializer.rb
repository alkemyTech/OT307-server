# frozen_string_literal: true

class MemberSerializer
  include JSONAPI::Serializer
  attributes :name, :description, :facebook_url, :instagram_url, :linkedin_url
end
