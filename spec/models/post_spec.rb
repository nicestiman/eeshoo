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
#  author_id  :integer
#

require 'spec_helper'

describe Post do

  before do
    @group = Group.create(name: "Noodle Club", location: "US.CO")
    @author = @group.users.create(first: "Jane", last: "Doe", email: "jane_doe_fake@example.com", password: "testpass", password_confirmation: "testpass")
    @post = @group.posts.build(content: "This is a test post", title: "Test")
    @post.author = @author
  end

  subject { @post }

  it { should respond_to(:content) }
  it { should respond_to(:title)   }
  it { should respond_to(:group_id) }
  it { should respond_to(:group) }
  it { should respond_to(:author) }
  it { should respond_to(:author_id) }
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

  #tests for posts location method(s)
  describe "when trying to find posts in a country" do
    let(:country) { "US" }
    before do
      @group2 = Group.create(name: "Second Test Group", location: "BR.RJ")
      @post2 = @group2.posts.new(title: "Test for other country", content: "This should not be returned")
      @post2.author = @author
      @post2.save
      @posts = Post.where_location(:country)
    end

    it "should only have the first post" do
      expect(@posts).to include(@post)
      expect(@posts).not_to include(@post2)
    end
  end
end
