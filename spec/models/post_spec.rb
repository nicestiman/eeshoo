# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  content    :text(255)
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :integer
#

require 'spec_helper'

describe Post do

  before do
    @group = Group.create(name: "Noodle Club", location: "Denver, Colorado, USA")
    @post = @group.posts.build(content: "This is a test post", title: "Test") 
  end

  subject { @post }

  it { should respond_to(:content) }
  it { should respond_to(:title)   }
  it { should respond_to(:group_id) }
  it { should respond_to(:group) }
  its(:group) { should == @group }

  it { should be_valid }

  describe "when content is not present" do
    before { @post.content = " " }
    it { should_not be_valid }
  end

  describe "when title is not present" do
    before { @post.title = " " }
    it { should_not be_valid }
  end

  describe "accesible attributes" do
    it "should not allow access to group_id" do
      expect { Post.new(group_id: @group.id) }.to raise_error (ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "when group_id is not present" do
    before { @post.group_id = nil }
    it { should_not be_valid }
  end
end
