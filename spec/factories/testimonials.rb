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
FactoryBot.define do
  factory :testimonial do
    name { "MyString" }
    content { "MyString" }
  end
end
