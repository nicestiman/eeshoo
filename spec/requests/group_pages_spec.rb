require 'spec_helper'

describe "Group pages" do
  let(:group) { FactoryGirl.create(:group) }

  subject { page }

  describe "new group page" do
    before { visit new_group_path }

    let(:submit) { "Create" }

    describe "with invalid information" do
      it "should not create a group" do
        expect { click_button submit }.not_to change(Group, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_content "error" }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",     with: group.name + "2"
        fill_in "Location", with: group.location
      end

      it "should create a group" do
        expect { click_button submit }.to change(Group, :count).by(1)
      end
    end
  end

  describe "index group page" do
    let(:group2) { FactoryGirl.create(:group) }
    before do
      @groups = [group, group2] 
      visit groups_path + ".json"
    end

    it "should list each group" do
      @groups.each do |group|
        page.should have_content("group_id: #{group.id}")
        page.should have_content("group_name: #{group.name}")
        page.should have_content("group_location: #{group.location}")
      end
    end
  end

  describe "group profile page with posts" do
    before do
      group.posts.create(content: "this is a test post", title: "Test post")
      group.posts.create(content: "this is another test post", title: "Second Test Post")
      visit group_path(group.id)
    end

    it { should have_selector("h1", text: "Profile Page") }
    it { should have_selector("h1", text: group.name)    }
    
    it "should list each post" do
      group.posts.each do |post|
        page.should     have_selector("li", text: post.title)
        page.should_not have_content(post.content)
      end
    end
  end

  describe "group profile page without posts" do
    before do
      visit group_path(group.id)
    end

    it { should have_selector("li", text: "You haven't made any posts yet") }
  end

  describe "members page" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      visit members_path(group.id)
    end

    it { should have_selector('title',  text: "Group members") }
    it { should have_selector('h1',     text: "Members of #{group.name}") }

    describe "when a Group has members" do
      before(:all) do
        30.times do
          group.users << FactoryGirl.create(:user)
        end
        visit members_path(group.id)
      end
      after(:all) { group.users.delete_all }

      it "should list each user" do
        group.users.each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end

    describe "when a User joins a group" do
      let(:join) { "Join this group" }

      describe "and is not signed in" do
        before { click_button join }

        it { should have_selector('title', text: 'Sign in') }
      end
    end
  end
end
