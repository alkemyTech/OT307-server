# frozen_string_literal: true

class NewsSerializer
  include JSONAPI::Serializer

  attributes :content, :name
  attributes :image do |news|
    news.image.service_url if news.image.attached?
  end

  # belongs_to :category
end
