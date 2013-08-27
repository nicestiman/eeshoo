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

require 'spec_helper'

describe RolePermission do
  it{should respond_to :name }
  it{should respond_to :key  }
end
