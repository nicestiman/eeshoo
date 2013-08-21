# == Schema Information
#
# Table name: assignments
#
#  id         :integer          not null, primary key
#  group_id   :integer
#  role       :string(255)      default("user")
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
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
    let(:default) { "user" }
    
    it "should be the default role" do
      @assignment.role.should == default
    end
  end

  describe "changing role through a user" do
    let(:new_role) { "AdmIn" }
    before do
      @user.set_role_to(new_role, @group)
    end

    it "should be the new role" do
      expect(@group.users.find(@user.id).role).to eq(new_role.downcase)
    end
  end

  describe "changing role through a group" do
    let(:new_role) { "aDmIn" }
    before do
      @group.set_role_to(new_role, @user)
    end

    it "should be the new role" do
      expect(@user.groups.find(@group.id).role).to eq(new_role.downcase)
    end
  end
end
