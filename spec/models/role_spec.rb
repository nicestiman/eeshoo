# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Role do
  before do
    @role = FactoryGirl.create(:role)
  end
  
  it {should respond_to(:name)}
  
  it {should respond_to(:permissions)}
  
  it "should be able to assine and retreave a name" do
    @role.name = "tom"
    @role.name.should eql("tom")
  end

  it " should be able to add and retrive a permission" do
    @permission = FactoryGirl.create(:permission)
    @role.permissions << @permission
    @role.permissions.first.name.should eql(@permission.name)
  end
  describe "create_from_defaults methoud" do
    let(:defaultname) {"admin"}
    before do
      @role = Role.create_from_defaults(defaultname)
    end
    it "should create from a default object yaml file" do 
      @role.should_not be_nil
    end
    it "should have permissions" do
      @role.permissions.should_not be_nil
    end
  end
end
