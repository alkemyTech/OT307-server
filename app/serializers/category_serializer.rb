# frozen_string_literal: true

class CategorySerializer
  include JSONAPI::Serializer

  attributes :name, :description
  attributes :image do |category|
    category.image.service_url if category.image.attached?
  end
  # has_many git :news
end
