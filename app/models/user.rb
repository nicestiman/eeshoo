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

  # Checks to see if a user can do an action in a spasfic group.
  #
  #  ==== Examples
  #  user.can?(:post, in: group.id )
  #
  def can?(permission, options)
    user_permissions = role_for(options[:in]).permissions
    user_permissions.each do |user_permission|
      if user_permission.key == permission.to_s
        return true
      end
    end
    return false
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

  def name
    return self.first+" "+self.last
  end
  
  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
