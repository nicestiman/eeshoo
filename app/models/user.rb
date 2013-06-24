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

module AddRole
  def find_groups
    groups = self.groups
    assignments = self.assignments

    groups.each do |group|
      assignments.each do |role|
        group[:role] = role[:role] if group[:id] == role[:group_id]
      end
    end
    return groups
  end
end
  


class User < ActiveRecord::Base
  attr_accessible :email, :first, :last, :password, :password_confirmation

  has_many :assignments
  has_many :groups, :through => :assignments, select: 'groups.*, assignments.role AS role' 
  #has_many :groups, :through => :assignments, finder_sql: "SELECT `groups`.*, `assignments`.`role` FROM `groups` LEFT JOIN `assignments` ON `groups`.`id` = `assignments`.`group_id` WHERE `assignments`.`user_id` = 22"

  has_secure_password

  before_save { |user| user.email = email.downcase }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :first, presence: true, length: { maximum: 30 }
  validates :last, presence: true, length: { maximum: 30 }
  validates :password, presence: true, length: { minimum: 8 }
  validates :password_confirmation, presence: true
end
