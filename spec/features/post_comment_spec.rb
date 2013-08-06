require 'spec_helper'

feature "I want to post a comment" do 
  before do
    #make a post that a comment will be affixed to
    @post = FactoryGirl.create(:post)
    
    #assine the auther to the post(
    @author = @post.author
    
    #get the group of the post
    @group = @post.group
    @group_member = FactoryGirl.create(:user) 

    @group.users << @group_member   
    @other_user = FactoryGirl.create(:user)
  end

  let(:content) {"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus pulvinar euismod lectus malesuada tincidunt."}
  subject { page }

  context "if I am the author" do
    before do
      sign_in @author
      visit group_post_path(@group.id, @post.id)
    end
    
    scenario "I should be able to post a comment" do
      fill_in "comment_message", with: "this was not my best work"
      expect {click_button "Comment"}.to change(Comment, :count).by(1)
    end
    
    scenario "my post should show up on the post page" do 
      fill_in "comment_message", with: content
      click_button "Comment"
      expect(page).to have_content( content )
    end
  end
  
  context "if I am a member of the group" do 
    before do 
      sign_in @group_member
      visit group_post_path(@group.id, @post.id)
    end
    
    scenario "I should be able to to post a comment" do
      fill_in "comment_message", with: content
      expect {click_button "Comment"}.to change(Comment, :count).by(1)
    end
    
    scenario "my post should show up on the post page" do 
      fill_in "comment_message", with: content
      click_button "Comment"
      expect(page).to have_content( content )
    end
  end

  context "if I am not a member" do
    before do 
      sign_in @other_user
      visit group_post_path(@group.id, @post.id)
    end
    
    scenario "I should not be able to to post a comment" do
      post(group_post_comments_path(@group.id, @post.id), {params: {message: "this is a test" }})
    end
  end
end
