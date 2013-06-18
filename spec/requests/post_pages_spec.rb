require 'spec_helper'

describe "Post pages" do
  before do
    @group = Group.create(name: "Test Group", location: "Los Angeles, California, USA")
    @post = @group.create(content: "This is a test post", title: "Test")
  end

  subject { page }

  describe "new post page" do

  end

  describe "index" do
    before do
      @post1 = Post.create(content: "This is test post #1", title: "Post 1")
      @post2 = Post.create(content: "This is test post #2", title: "Post 2")
      visit posts_path + ".json"
    end

    it "should list each post" do
      #for post 1
      it { should have_content("post_id:  #{@post1.id}"      ) }
      it { should have_content("title:    #{@post1.title}"   ) }
      it { should have_content("content:  #{@post1.content}" ) }


      #for post 2
      it { should have_content("post_id:  #{@post2.id}"      ) }
      it { should have_content("title:    #{@post2.title}"   ) }
      it { should have_content("content:  #{@post2.content}" ) }
    end
  end
end
