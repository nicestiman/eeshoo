# == Schema Information
#
# Table name: assignments
#
#  id         :integer          not null, primary key
#  role       :string(255)
#  group_id   :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Assignment do
  before do 
    @user = User.create(first: "Jane", last: "Doe", email: "test2@example.com", password: "testPass", password_confirmation: "testPass")
    @group = @user.groups.create(name: "Fake Group", location: "Phoenix, Arizona, USA")
  end

  subject { @user.assignments.find_by_group_id(@group.id) }

  it { should be_valid }
  it { should respond_to(:user) }
  it { should respond_to(:group) }
end
