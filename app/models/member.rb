# == Schema Information
#
# Table name: members
#
#  id           :bigint           not null, primary key
#  description  :string
#  facebookUrl  :string
#  instagramUrl :string
#  linkedinUrl  :string
#  name         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Member < ApplicationRecord
end
