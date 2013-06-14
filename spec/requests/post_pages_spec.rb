require 'spec_helper'

describe "Post pages" do

  subject { page }

  describe "new post page" do
    before { visit new_post_path + ".json" }

    it { should have_content("New Post") }
  end

  describe "index" do
    before do
      Post.create(content: "This is test post #1", title: "Post 1")
      Post.create(content: "This is test post #2", title: "Post 2")
      visit posts_path + ".json"
    end

    it "should list each post" do
      Post.all.each do |post|
        page.should have_content("post_id: #{post.id}"         )
        page.should have_content("title: #{post.title}"    )
        page.should have_content("content: #{post.content}")
      end
    end
  end
end
