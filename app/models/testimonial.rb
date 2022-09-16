# == Schema Information
#
# Table name: testimonials
#
#  id         :bigint           not null, primary key
#  content    :string
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Testimonial < ApplicationRecord
    validates :name, presence: true
end
