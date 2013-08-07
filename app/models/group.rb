# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  location   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Group < ActiveRecord::Base
  attr_accessible :location, :name
  has_many :posts
  
  has_many :assignments
  has_many :users, :through => :assignments
  has_and_belongs_to_many :roles
  validates :name, presence: true, length: { maximum: 40 }, uniqueness: true
  validates :location, presence: true

  def remove(user)
    assignment = self.assignments.find_by_user_id(user.id)
    assignment.delete
    #reevaluate assignment, don't use the cached variable
    assignment = self.assignments.find_by_user_id(user.id)
    #return boolean for successfull removal
    assignment.nil?
  end

  def is_role_of?(user, role = "admin")
    self.users.find(user.id).role == role.downcase
  end

  def set_role_to(new_role, user)
    new_role.downcase!

    if self.users.include?(user)
      assign = self.assignments.find_by_user_id(user.id)
      assign.role = new_role
      assign.save
    else
      return false
    end
  end
end
