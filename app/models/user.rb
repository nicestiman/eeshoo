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
#  remember_token  :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :email, :first, :last, :password, :password_confirmation

  has_many :assignments
  has_many :groups, :through => :assignments
  has_many :posts, foreign_key: "author_id"

  has_secure_password

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :first, presence: true, length: { maximum: 30 }
  validates :last, presence: true, length: { maximum: 30 }
  validates :password, presence: true, length: { minimum: 8 }
  validates :password_confirmation, presence: true
  after_validation { self.errors.messages.delete(:password_digest) }

  def name
    return self.first+" "+self.last
  end
  
  def role_for(group, options = {})
    
    assignment = self.assignments.find_by_group_id(group)
    if options[:is].nil?
      assignment.role
    else
      assignment.role_id = 
        options[:is].id
      assignment.save
    end
  end

  def is_role_of?(group, role = "admin")
    self.groups.find(group.id).role == role.downcase
  end
  
  def set_role_to(new_role, group)
    new_role.downcase!
    
    if self.groups.include?(group)
      assign = self.assignments.find_by_group_id(group.id)
      assign.role = new_role
      assign.save
    else
      return false
    end
  end

  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
