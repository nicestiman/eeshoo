# == Schema Information
#
# Table name: assignments
#
#  id         :integer          not null, primary key
#  role       :string(255)
#  group_id   :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Assignment < ActiveRecord::Base
  attr_accessible :group_id, :role, :user_id

  belongs_to :group
  belongs_to :user
end
