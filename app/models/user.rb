# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  first           :string(255)
#  last            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)

class User < ActiveRecord::Base
  attr_accessible :email, :first, :last, :password, :password_confirmation

  has_many :assignments
  has_many :groups, :through => :assignments, select: 'groups.*, assignments.role AS role' 

  has_secure_password

  before_save { |user| user.email = email.downcase }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :first, presence: true, length: { maximum: 30 }
  validates :last, presence: true, length: { maximum: 30 }
  validates :password, presence: true, length: { minimum: 8 }
  validates :password_confirmation, presence: true
  after_validation { self.errors.messages.delete(:password_digest) }
end
