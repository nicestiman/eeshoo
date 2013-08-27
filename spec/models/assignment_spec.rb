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
    @assignment = Assignment.new()
    @assignment.user  = FactoryGirl.create(:user)
    @assignment.group = FactoryGirl.create(:group)
    @assignment.role  = FactoryGirl.create(:role)
  end

  subject { @assignment }

  it { should be_valid }
  it { should respond_to(:user) }
  it { should respond_to(:group) }
  it { should respond_to(:role) }
  
  describe "validation" do

    it "should not be valid if no user"  do 
      @assignment.user  = nil
      should_not be_valid
    end

    it "should not be valid if no group" do
      @assignment.group = nil
      should_not be_valid
    end

    it "should be valid if no role"  do
      @assignment.role  = nil
      should be_valid
    end
    
    it "should not be valid if group and user are not unique" do
      assignment1 = @assignment.dup
      assignment1.role = FactoryGirl.create(:role) 
      assignment1.save
      should_not be_valid
    end

    it "should be valid if user is not unique" do
      assignment1       = @assignment.dup
      assignment1.role  = FactoryGirl.create(:role) 
      assignment1.group = FactoryGirl.create(:group)
      
      assignment1.save
      should be_valid
    end
    
    it "should be valid if group is not unique" do
      assignment1       = @assignment.dup
      assignment1.role  = FactoryGirl.create(:role) 
      assignment1.user  = FactoryGirl.create(:user)
      
      assignment1.save
      should be_valid
    end
  end
  describe "if role is not defined use the group default role" do
    let(:group_default_role) { @assignment.group.default_role}
    
    it "role should be the group default role" do
      @assignment.role = nil
      @assignment.save
      @assignment.role.name.should eql group_default_role.name
    end
  end
end
