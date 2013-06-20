# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Post do
  before { @post = Post.new(content: "This is a test post", title: "Test") }

  subject { @post }

  it { should respond_to(:content) }
  it { should respond_to(:title)   }

  describe "when content is not present" do
    before { @post.content = " " }
    it { should_not be_valid }
  end

  describe "when title is not present" do
    before { @post.title = " " }
    it { should_not be_valid }
  end
end
