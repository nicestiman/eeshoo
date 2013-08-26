# == Schema Information
#
# Table name: contents
#
#  id         :integer          not null, primary key
#  post_id    :integer
#  key        :string(255)
#  value      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Content do
  before do
    @post = FactoryGirl.create(:post)
    @content = FactoryGirl.build(:content)
    @content.post = @post
  end

  subject { @content }

  it { should respond_to(:post_id) }
  it { should respond_to(:post) }
  it { should respond_to(:key) }
  it { should respond_to(:value) }

  it { should be_valid }

  describe "when key is nil" do
    before { @content.key = " " }
    it { should_not be_valid }
  end

  describe "when value is nil" do
    before { @content.value = " " }
    it { should be_valid }
  end

  describe "when post is not associated" do
    before { @content.post_id = " " }
    it { should_not be_valid }
  end
end
