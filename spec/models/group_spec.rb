require 'spec_helper'

describe Group do
  before { @group = Group.new(name: "Noodle Club", location: "3500 S Wadsworth Blvd, Lakewood, Colorado, 80235") }

  subject { @group }

  it { should respond_to(:name)     }
  it { should respond_to(:location) }
end
