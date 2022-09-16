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
class User < ApplicationRecord
  include Discard::Model

  has_secure_password
  has_one_attached :image

  belongs_to :role
  has_many :comments, dependent: :destroy
  has_many :contacts, dependent: :nullify

  validates :first_name, :last_name, :email, :password, presence: true
  validates :email, uniqueness: true
end
