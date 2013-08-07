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

require 'spec_helper'

describe Assignment do
  before do 
    @user = User.create(first: "Jane", last: "Doe", email: "test2@example.com", password: "testPass", password_confirmation: "testPass")
    @group = @user.groups.create(name: "Fake Group", location: "US.AZ")
    @assignment = @user.assignments.find_by_group_id(@group.id)
  end

  subject { @assignment }

  it { should be_valid }
  it { should respond_to(:user) }
  it { should respond_to(:group) }
  it { should respond_to(:role) }

  describe "default role" do 
    
    it "should be the default role"
  end

  describe "changing role through a user" do
    
    it "should be the new role"
  end

  describe "changing role through a group" do
    
    it "should be the new role"
  end
end
