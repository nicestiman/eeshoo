# == Schema Information
#
# Table name: assignments
#
#  id         :integer          not null, primary key
#  group_id   :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  role_id    :integer
#

class Assignment < ActiveRecord::Base
  attr_accessible :group_id, :role, :user_id

  belongs_to :group
  belongs_to :user
  belongs_to :role

end
