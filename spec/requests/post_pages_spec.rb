require 'spec_helper'

describe "Post pages" do

  subject { page }

  describe "new post page" do
    before { visit newpost_path }

    it { should have_content("New Post") }
  end

  describe "index" do
    before do
      Post.create(content: "This is test post #1", title: "Post 1")
      Post.create(content: "This is test post #2", title: "Post 2")
      visit '/posts'
    end

    it "should list each post" do
      Post.all.each do |post|
        page.should have_content("id: #{post.id}"         )
        page.should have_content("title:#{post.title}"    )
        page.should have_content("content:#{post.content}")
      end
    end
  end
end
