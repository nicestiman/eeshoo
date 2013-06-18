require 'spec_helper'

describe "Group pages" do
  subject { page }

  describe "new group page" do
    before { visit new_group_path }

    let(:submit) { "Create" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(Group, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_content "error" }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",     with: "Noodle Club"
        fill_in "Location", with: "Denver, Colorado, USA"
      end

      it "should create a group" do
        expect { click_button submit }.to change(Group, :count).by(1)
      end
    end
  end

  describe "index group page" do
    before do
      Group.create(name: "Noodle Club", location: "Denver, Colorado, USA")
      Group.create(name: "Secret Box Club", location: "New York, New York, USA")
      visit groups_path + ".json"
    end

    it "should list each group" do
      Group.all.each do |group|
        page.should have_content("group_id: #{group.id}")
        page.should have_content("group_name: #{group.name}")
        page.should have_content("group_location: #{group.location}")
      end
    end
  end

  describe "group profile page with posts" do
    before do
      @group = Group.create(name: "Test Group", location: "Los Angeles, California, USA")
      @group.posts.create(content: "this is a test post", title: "Test post")
      @group.posts.create(content: "this is another test post", title: "Second Test Post")
      visit group_path(@group.id)
    end

    it { should have_selector("h1", text: "Profile Page") }
    it { should have_selector("h1", text: @group.name)    }
    
    it "should list each post" do
      @group.posts.each do |post|
        page.should     have_selector("li", text: @group.title)
        page.should_not have_content(@group.content)
      end
    end
  end
end
