# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  location   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Group do
  before { @group = Group.new(name: "Noodle Club", location: "3500 S Wadsworth Blvd, Lakewood, Colorado, 80235") }

  subject { @group }

  #tests for group model
  it { should respond_to(:name)     }
  it { should respond_to(:location) }
  it { should respond_to(:posts)    }

  #test for user model relation
  it { should respond_to(:users) }

  it { should respond_to(:roles)}

  it { should respond_to (:default_role)}

  it { should be_valid }

  describe "when name is not present" do
    before { @group.name = "" }

    it { should_not be_valid }
  end

  describe "when location is not present" do
    before { @group.location = "" }

    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @group.name = "a" * 41 }

    it { should_not be_valid }
  end

  describe "when it creates a user" do
    before do
      @group.save
      @user = @group.users.create(first: "Jane", last: "Doe", email: "test@example.com", password: "testpass", password_confirmation: "testpass")
    end

    let(:group_user) { @group.users.find(@user.id) }

    it "should have a user" do
      group_user.should == @user
    end
  end


  describe "when it is assigned a user" do
    before do
      @group.save
      @user = User.create(first: "Jane", last: "Doe", email: "test@example.com", password: "testPass", password_confirmation: "testPass")
      @group.users << @user
    end

    let(:group_user) { @group.users.find(@user.id) }

    it "should have a user" do
      group_user.should == @user
    end
  end
  
  describe "if no default role is defined" do
    let(:default_name){ "default" }
    
    it "should set a defalult role" do
      @group.default_role = nil
      @group.save
      @group.default_role.name.should  eql default_name
    end
  end
end
