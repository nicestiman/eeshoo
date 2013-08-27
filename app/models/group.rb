# == Schema Information
#
# Table name: groups
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  location        :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  default_role_id :integer
#

class Group < ActiveRecord::Base
  DEFAULT_ROLE = "subscriber"
  attr_accessible :location, :name
  has_many :posts
  
  has_many :assignments
  has_many :users, :through => :assignments
  has_and_belongs_to_many :roles

  belongs_to :default_role, class_name: "Role"
  validates  :name, presence: true, length: { maximum: 40 }, uniqueness: true
  validates  :location, presence: true
  before_save :set_default_role

  def set_default_role
    if self.default_role.nil?
       self.default_role_id = Role.create_from_defaults(DEFAULT_ROLE).id
    end
  end

  def build_role(name, type)
    role = Role.create(name: name)
    
    permissions = YAML.load_file( "#{Rails.root}/app/models/default_records/#{type.underscore}_default.yaml")  
    permissions.each do |permission|
      role.permissions.create(name: permission["name"], key: permission["key"])
    end
    role
  end

  
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
  
  def role_for(group, options = {})
    assignment = self.assignments.find_by_user_id(group)
    if options[:is].nil?
      assignment.role
    else
      assignment.role_id = 
        options[:is].id
      assignment.save
    end
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
