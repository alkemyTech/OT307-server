# frozen_string_literal: true

# == Schema Information
#
# Table name: organizations
#
#  id           :bigint           not null, primary key
#  aboutUsText  :text
#  address      :string
#  discarded_at :datetime
#  email        :string           not null
#  name         :string           not null
#  phone        :integer
#  welcomeText  :text             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_organizations_on_discarded_at  (discarded_at)
#
FactoryBot.define do
  factory :organization do
    name { 'MyString' }
    address { 'MyString' }
    phone { 1 }
    email { 'MyString' }
    welcomeText { 'MyText' }
    aboutUsText { 'MyText' }
  end
end
