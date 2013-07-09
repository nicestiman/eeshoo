require 'spec_helper'

describe Map do
  before { @map = Map.new }

  subject{ @map }

  it { should respond_to :location }
  it { should respond_to :topo     }

  context "with filled out constructor" do

    before { @map = Map.new "BRA" }

    it { @map.location.should eql "BRA" }
  end

  context "with empty constuctor" do

    it { @map.location.should eql ""}
    it { @map.topo.should have_key :land}
  end
end
