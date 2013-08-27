# == Schema Information
#
# Table name: role_permissions
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  key        :string(255)
#  role_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class RolePermission < ActiveRecord::Base
  attr_accessible :name, :key

  belongs_to :role
end
