require 'spec_helper'

describe "Post pages" do
  before do
    @group1 = Group.create(name: "Test Group", location: "Los Angeles, California, USA")
    @post = @group1.posts.new(content: "This is a test post", title: "Test")
  end

  subject { page }

  describe "new post page" do
    before { visit new_group_post_path(@group1.id) }

    let(:submit) { "Post" }

    it { should have_selector("h1", text: "New Post") }

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

      describe "should redirect to group homepage" do
        before { click_button submit }

        it { should have_content("Profile Page for #{@group1.name}")  }
        it { should have_content(@post.title)                         }
      end
    end
  end

  describe "index" do
    before do
      @post1 = @group1.posts.create(content: "This is test post #1", title: "Post 1")
      @post2 = @group1.posts.create(content: "This is test post #2", title: "Post 2")
      @posts = [@post1, @post2]
      visit group_posts_path(@group1.id) + ".json"
    end

    it "should list all posts" do
      @posts.each do |post|
        page.should have_content("post_id: #{post.id}"      )
        page.should have_content("title: #{post.title}"     )
        page.should have_content("content: #{post.content}" )
      end
    end
  end

  describe "tiered posts" do
    before do
      @group2 = Group.create(name:"Second Test Group", location: "Rio de Janeiro, Rio de Janeiro, Brazil")

      @post1 = @group1.posts.create(content: "This is a test post for the first group",
                                    title: "group1 test")
      @post2 = @group2.posts.create(content: "This is a test post for the second group",
                                    title: "group2 test")
      @posts = [@post1, @post2]

      visit posts_path + ".json" 
    end

    it "should list posts for all groups" do
      @posts.each do |post|
        page.should have_content("\"id\":#{post.id}"      )
        page.should have_content("\"content\":\"#{post.content}\"" )
        page.should have_content("\"group_id\":#{post.group_id}")
      end
    end
  end      
end
