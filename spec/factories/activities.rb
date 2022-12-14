# frozen_string_literal: true

# == Schema Information
#
# Table name: activities
#
#  id           :bigint           not null, primary key
#  content      :string
#  discarded_at :datetime
#  name         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_activities_on_discarded_at  (discarded_at)
#
FactoryBot.define do
  factory :activity do
    name { 'MyString' }
    content { 'MyString' }
  end
end
