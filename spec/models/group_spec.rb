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

  it { should respond_to(:name)     }
  it { should respond_to(:location) }
  it { should respond_to(:posts)    }

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
end
