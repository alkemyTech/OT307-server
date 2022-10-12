# frozen_string_literal: true

class CategorySerializer
  include JSONAPI::Serializer
  attributes :name, :description

  has_many :news
end
