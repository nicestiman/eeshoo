# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Role < ActiveRecord::Base
  attr_accessible :name
  
  has_many :permissions, class_name: "RolePermission"
  has_and_belongs_to_many :groups
  ###  
  # creates a role and populatest it with a set of permissions
  # defined in a yaml file
  def self.create_from_defaults(default)
    # get the file location to parse to make the object
    filename = 
      "#{Rails.root}/config/default_records/#{default.underscore}_role.yaml" 
    
    #parse the file for data to be put into the file name
    yaml = 
      YAML.load_file(filename)
    
    #slpit up the yaml file into maigale sizes
    role_name   = yaml["name"]
    permissions = yaml["permissions"]
    logger.debug "the yaml file parses as"+yaml.to_json 
    role = Role.create(name: role_name)
    permissions.each do |permission|
      role.permissions.create(
        name: permission["name"], 
        key: permission["key"]
      )
    end
    role
  end
end
