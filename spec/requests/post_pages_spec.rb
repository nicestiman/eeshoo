require 'spec_helper'

describe "Post pages" do

  subject { page }

  describe "new post page" do
    before { visit newpost_path }

    it { should have_content("New Post") }
  end

  describe "show posts page" do
    before { visit posts_path }

    it { should have_selector('title', 'Posts') }
  end
end
