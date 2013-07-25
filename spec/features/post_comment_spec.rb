require 'spec_helper'

feature "I want to post a comment" do 
  before do
    #make a post that a comment will be affixed to
    @post = FactoryGirl.create(:post)
    
    #assine the auther to the post(
    @author = @post.author
    
    #get the group of the post
    @group = @post.group
  end

  subject { page }

   context "if I am the author" do
    before do
      sign_in @author
      visit group_post_path(@group.id, @post.id)
    end
    
    it "I should be able to post a comment" do
      fill_in "comment_message", with: "this was not my best work"
      expect {click_button "Comment"}.to change(Comment, :count).by(1)
    end
  end
end
