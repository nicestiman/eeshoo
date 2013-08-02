class Role < ActiveRecord::Base
  attr_accessible :name
  
  has_many :permissions, class_name: "RolePermissions"
end
