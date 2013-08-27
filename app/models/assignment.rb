# == Schema Information
#
# Table name: assignments
#
#  id         :integer          not null, primary key
#  group_id   :integer
#  role       :string(255)      default("user")
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  role_id    :integer
#

class Assignment < ActiveRecord::Base

  belongs_to :group
  belongs_to :user
  belongs_to :role

  validates  :group_id, presence: true
  validates  :user_id,  presence: true, uniqueness: {scope: :group_id}

  before_save :set_default_role

  def set_default_role
    if self.role.nil?
      role = Group.find(self.group_id).default_role
      self.role_id = role.id
    end
  end
end
