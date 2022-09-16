# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  discarded_at    :datetime
#  email           :string
#  first_name      :string
#  index           :bigint
#  last_name       :string
#  password_digest :string
#  photo           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_discarded_at  (discarded_at)
#  index_users_on_email         (email) UNIQUE
#
FactoryBot.define do
  factory :user do
    first_name { 'MyString' }
    last_name { 'MyString' }
    email { 'MyString' }
    password_digest { 'MyString' }
    photo { 'MyString' }
  end
end
