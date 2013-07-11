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
  has_many :users, :through => :assignments, select: 'users.*, assignments.role AS role'

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
end
