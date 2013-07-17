require 'spec_helper'

describe "Post pages" do
  before do
    @group1 = Group.create(name: "Test Group", location: "US.CA")
    @author = @group1.users.create(first: "Jane", last: "Doe", email: "jane_doe_fake@example.com", password:"testpass", password_confirmation: "testpass")
    @post = @group1.posts.new(content: "This is a test post", title: "Test")
  end

  subject { page }

  describe "show post page" do
    before do
      @post.author = @author
      @post.save
      visit group_post_path(@group1.id, @post.id)
    end

    it { should have_selector("title",  text: "Show Post") }
    it { should have_selector("h1",     text: @post.title) }
    it { should have_selector("p",      text: @post.content) }
    it { should have_selector("a",      href: group_path(@group1.id)) }
    it { should have_selector("a",      href: user_path(@author.id)) }

    describe "if current user is the author" do
      before do
        sign_in @author
        visit group_post_path(@group1.id, @post.id)
      end

      it { should have_selector("a",    text: "Delete this post?") }

      it "should delete the post" do
        expect { click_link "Delete this post?" }.to change(Post, :count).by(-1)
      end
    end

    describe "if the current user is not the author" do

      it { should_not have_selector("a",  text: "Delete this post?") }
    end
  end

  describe "new post page, with signed in user" do
    before { sign_in @author; visit new_group_post_path(@group1.id) }

    let(:submit) { "Post" }

    it { should have_selector("title", text: "New Post") }

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

  describe "new post page, when not signed in" do
    before { visit new_group_post_path(@group1.id) }

    it { should have_selector('title', text: 'Sign in') }

    describe "after signing in" do
      before do
        fill_in "Email",    with: @author.email
        fill_in "Password", with: @author.password
        click_button "Sign in"
      end

      it { should have_selector('title', text: "New Post") }
    end
  end

  describe "new post page, when not a member" do
    let(:wrong_user) { FactoryGirl.create(:user) }
    before do
      sign_in wrong_user
      visit new_group_post_path(@group1.id)
    end

    it { should have_selector('title', text: "Group members") }

    describe "after submitting" do
      before { click_link "Join this group" }

      it { should have_selector('title', text: "New Post") }
    end
  end

  describe "index" do
    before do
      @post1 = @group1.posts.new(content: "This is test post #1", title: "Post 1")
      @post2 = @group1.posts.new(content: "This is test post #2", title: "Post 2")
      @posts = [@post1, @post2]
      @posts.each do |post|
        post.author = @author
        post.save
      end
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
      @group2 = Group.create(name:"Second Test Group", location: "BR.RJ")
      @post1 = @group1.posts.new(content: "This is a test post for the first group",
                                    title: "group1 test")
      @post2 = @group2.posts.new(content: "This is a test post for the second group",
                                    title: "group2 test")
      @posts = [@post1, @post2]
      @posts.each do |post|
        post.author = @author
        post.save
      end
      visit posts_path  
    end

    it "should list posts for all groups" do
      @posts.each do |post|
        page.should have_content("\"id\":#{post.id}"      )
        page.should have_content("\"content\":\"#{post.content}\"" )
        page.should have_content("\"group_id\":#{post.group_id}")
      end
    end

    describe "when looking for posts in a country" do
      before do
        visit '/posts?location=US'    
      end

      it "should list only posts in the US" do
        page.should have_content("\"id\":#{@post1.id}")
        page.should have_content("\"content\":\"#{@post1.content}\"" )
        page.should have_content("\"group_id\":#{@post1.group_id}")

        page.should_not have_content("\":id\":#{@post2.id}")
        page.should_not have_content("\"content\":\"#{@post2.content}\"" )
        page.should_not have_content("\"group_id\":#{@post2.group_id}")
      end
    end
  end      
end
