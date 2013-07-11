require 'spec_helper'

describe "Group pages" do
  before { @group = Group.create(name: "Test Group", location: "Denver, Colorado, USA") }

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
        fill_in "Name",     with: @group.name + "2"
        fill_in "Location", with: @group.location
      end

      it "should create a group" do
        expect { click_button submit }.to change(Group, :count).by(1)
      end
    end
  end

  describe "index group page" do
    before do
      @group2 = Group.create(name: "Test Group 2", location: "Los Angeles, CA")
      @groups = [@group, @group2] 
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
      @group.posts.create(content: "this is a test post", title: "Test post")
      @group.posts.create(content: "this is another test post", title: "Second Test Post")
      visit group_path(@group.id)
    end

    it { should have_selector("h1", text: "Profile Page") }
    it { should have_selector("h1", text: @group.name)    }
    
    it "should list each post" do
      @group.posts.each do |post|
        page.should     have_selector("li", text: post.title)
        page.should_not have_content(post.content)
      end
    end
  end

  describe "group profile page without posts" do
    before do
      visit group_path(@group.id)
    end

    it { should have_selector("li", text: "You haven't made any posts yet") }
  end

  describe "members page" do
    let(:popular_group) { FactoryGirl.create(:group, name: "Popular Group" ) }
    before do
      visit members_path(popular_group.id)
    end

    it { should have_selector('title',  text: "Group members") }
    it { should have_selector('h1',     text: "Members of #{popular_group.name}") }

    describe "when a Group has members" do
      before(:all) do
        30.times do
          popular_group.users << FactoryGirl.create(:user)
        end
        visit members_path(popular_group.id)
      end

      after(:all) do
        User.delete_all
        Group.delete_all
        Assignment.delete_all
      end

      it "should list each user" do
        popular_group.users.each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end

    describe "when a User joins a group" do
      let(:user) { FactoryGirl.create(:user) }
      let(:join) { "Join this group" }

      describe "and is not signed in" do

        it { should_not have_selector('a', text: 'Join this group') }
      end

      describe "and is signed in" do
        before do
          sign_in user
          visit members_path(popular_group.id)
        end

        it { should have_selector('a', text: 'Join this group' ) }

        describe "but is already a member" do
          before do
            popular_group.users << user
            visit members_path(popular_group.id)
          end

          it { should_not have_selector('a', text: join) }
          
          describe "submitting a POST request to the Groups#assign action" do
            before { post assign_path(popular_group.id) }
            
            specify { response.should redirect_to(members_path(popular_group.id)) }

            it "should not assign the user" do
              expect { post assign_path(popular_group.id) }.not_to change(Assignment, :count)
            end
          end
        end

        describe "and isn't a member yet" do
          
          it { should have_selector('a', text: join) }
          it "should assign the user to the group" do
            expect { click_link join }.to change(Assignment, :count).by(1)
          end
          
          describe "there should be a success message" do
            before { click_link join }

            it { should have_selector('div.alert.alert-success', 
                                      text: 'You have successfully joined this group') }
          end
        end
      end
    end
  end
end
