# frozen_string_literal: true

# == Schema Information
#
# Table name: organizations
#
#  id            :bigint           not null, primary key
#  about_us_text :text
#  address       :string
#  discarded_at  :datetime
#  email         :string           not null
#  facebook_url  :string
#  instagram_url :string
#  linkedin_url  :string
#  name          :string           not null
#  phone         :integer
#  welcome_text  :text             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_organizations_on_discarded_at  (discarded_at)
#
class OrganizationSerializer
  include JSONAPI::Serializer
  attributes :name, :address, :email, :phone, :about_us_text, :welcome_text, :facebook_url,
             :instagram_url, :linkedin_url
end
