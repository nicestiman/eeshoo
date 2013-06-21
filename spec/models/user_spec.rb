# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  first      :string(255)
#  last       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe User do

  before { @user = User.new(first: "John", last: "Doe", email: "jdoe@example.com") }

  subject { @user }

  it { should respond_to(:first)  }
  it { should respond_to(:last)   }
  it { should respond_to(:email)  }

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

  describe "when first name is too long" do
    before { @user.first = "a" * 31 }
    it { should_not be_valid }
  end

  describe "when last name is too long" do
    before { @user.last = "a" * 31 }
    it { should_not be_valid }
  end
end
