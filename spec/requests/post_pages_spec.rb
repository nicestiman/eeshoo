require 'spec_helper'

describe "Post pages" do

  subject { page }

  describe "new post page" do
    before { visit new_post_path }

    it { should have_selector('title', 'New Post') }
  end

  describe "show posts page" do
    before { visit posts_path }

    it { should have_selector('title', 'Posts') }
  end
end
