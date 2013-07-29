# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  first           :string(255)
#  last            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#

require 'spec_helper'

describe User do

  before { @user = User.new(first: "John", last: "Doe", email: "jdoe@example.com", password: "testpass", password_confirmation: "testpass") }

  subject { @user }

  #tests for user model attributes
  it { should respond_to(:first)  }
  it { should respond_to(:last)   }
  it { should respond_to(:email)  }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }

  #tests for group relation
  it { should respond_to(:groups) }

  #tests for posts relation
  it { should respond_to(:posts) }

  it { should be_valid }

  describe "when first name is not present" do
    before { @user.first = " " }
    it { should_not be_valid }
  end

  describe "when last name is not present" do
    before { @user.last = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "when password confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "when first name is too long" do
    before { @user.first = "a" * 31 }
    it { should_not be_valid }
  end

  describe "when last name is too long" do
    before { @user.last = "a" * 31 }
    it { should_not be_valid }
  end

  describe "when password is too short" do
    before { @user.password = @user.password_confirmation = "a" * 7 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should not be valid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]

      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]

      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end
  end

  describe "when email is already taken" do
    before do
      user_clone = @user.dup
      user_clone.email = @user.email.upcase
      user_clone.save
    end

    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_with_invalid_password) { found_user.authenticate("invalid") }

      it { should_not == user_with_invalid_password }
      specify { user_with_invalid_password.should be_false }
    end
  end

  describe "a valid user" do
    before do
      @user.save
      @group1 = @user.groups.create(name: "test group 1", location: "Denver, Colorado, USA")
      @group2 = @user.groups.create(name: "test group 2", location: "Los Angeles, California, USA")
    end

    it "should be able to make groups" do
      @group1.should be_valid
      @group2.should be_valid
    end

    describe "should belong to two groups" do
      let(:first_group) { @user.groups.find(@group1.id) }
      let(:second_group)  { @user.groups.find(@group2.id) }

      it "should list each group" do
        @group1.should == first_group
        @group2.should == second_group
      end
    end

    describe "should have a role in a group" do
      before do
        @assignment = @user.assignments.find_by_group_id(@group1.id)
        @assignment.role = "admin"
        @assignment.save
      end
      let(:role) { @user.groups.find(@group1.id).role }

      it "should have the correct role" do
        role.should == "admin"
      end
    end
  end

  describe "when joins a group" do
    before do
      @user.save
      @group = Group.create(name: "Fake Group", location: "Pheonix, Arizona, USA")
      @user.groups << @group
    end
    let(:users_group) { @user.groups.find(@group.id)  }
    let(:groups_user) { @group.users.find(@user.id)   }

    it "should be a member of the group" do
      users_group.should == @group
      groups_user.should == @user
    end
  end
  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "method to check role" do
    let(:group) { FactoryGirl.create(:group) }
    before do
      @user.save
      @user.groups << group
      @user.set_role_to("AdMiN", group)
    end

    it "should evaluate that the role is incorrect" do
      expect(@user.is_role_of?(group, "walrus")).to eq(false)
    end

    it "should evaluate that the role is correct" do
      expect(@user.is_role_of?(group, "admin")).to eq(true)
    end

    it "should evaluate that the role is correct using the default" do
      expect(@user.is_role_of?(group)).to eq(true)
    end
  end
end
