require 'spec_helper'

describe "Post pages" do
  before do
    @group = Group.create(name: "Test Group", location: "Los Angeles, California, USA")
    @post = @group.posts.new(content: "This is a test post", title: "Test")
  end

  subject { page }

  describe "new post page" do
    before { visit new_group_post_path(@group.id) }

    let(:submit) { "Post" }

    it { should have_selector("h1", "New Post") }

    describe "with invalid information" do
      it "should not make a new post" do
        expect { click_button submit }.not_to change(Post, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_content("error") }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Title",    with: @post.title
        fill_in "Content",  with: @post.content
      end

      it "should make a new post" do
        expect { click_button submit }.to change(Post, :count).by(1)
      end
    end
  end

  describe "index" do
    before do
      @post1 = @group.posts.create(content: "This is test post #1", title: "Post 1")
      @post2 = @group.posts.create(content: "This is test post #2", title: "Post 2")
      @posts = [@post1, @post2]
      visit group_posts_path(@group.id) + ".json"
    end

    it "should list all posts" do
      @posts.each do |post|
        #for post 2
        page.should have_content("post_id: #{post.id}"      )
        page.should have_content("title: #{post.title}"     )
        page.should have_content("content: #{post.content}" )
      end
    end
  end
end
