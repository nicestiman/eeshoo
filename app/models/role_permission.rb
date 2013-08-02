class RolePermission < ActiveRecord::Base
  attr_accessible :name, :key

  belongs_to :role
end
