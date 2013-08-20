require 'spec_helper'

describe "Group pages" do
  before { @group = Group.create(name: "Test Group", location: "US.CO") }

  subject { page }

  describe "new group page" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit new_group_path
    end

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

    describe "with valid information", js: true do
      before do
        select "United States of America", from: "countrymenu"
        select "Colorado", from: "statemenu"
        fill_in "Name",     with: @group.name + "2"
      end

      it { should have_selector("input", type: "hidden") }
      it { should have_selector("select", name: "countrymenu") }
      it { should have_selector("select", name: "statemenu") }

      it "should not have an error" do
        click_button submit
        page.should_not have_content("Error")
        page.should_not have_content("error")
      end

      it "should create a new group" do
        expect { click_button submit }.to change(Group, :count).by(1)
      end

      it "should assign current user as admin" do
        click_button submit
        group_lookup = Group.find_by_name(@group.name + "2")
        expect(user.is_role_of?(group_lookup)).to eq(true)
      end

      it "should show the group profile page" do
        click_button submit
        page.should have_selector('title',  text: @group.name + "2")
        page.should have_selector('h1',     text: @group.name + "2")
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
    let(:author) { FactoryGirl.create(:user) }
    before do
      @post1 = @group.posts.new(content: "this is a test post", species: "default")
      @post2 = @group.posts.new(content: "this is another test post", species: "default")
      @posts = [@post1, @post2]
      @posts.each do |post|
        post.author = author
        post.save
      end
      visit group_path(@group.id)
    end

    it { should have_selector("a",  href: members_path(@group.id)) }
    it { should have_selector("h1", text: @group.name)    }
    
    it "should list each post" do
      @group.posts.each do |post|
        page.should     have_selector("a",  href: group_post_path(@group.id, post.id))
        page.should_not have_content(post.content)
      end
    end
  end

  describe "group profile page without posts" do
    before do
      visit group_path(@group.id)
    end

    it { should have_selector("a",  href: members_path(@group.id)) }
    it { should have_selector("li", text: "You haven't made any posts yet") }
  end

  describe "members page" do
    let(:popular_group) { FactoryGirl.create(:group, name: "Popular Group" ) }
    before do
      visit members_path(popular_group.id)
    end

    it { should have_selector('title',  text: "Members") }
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
      let(:join) { "Join this Group" }

      describe "and is not signed in" do

        it { should_not have_content(text: "Join this Group") }
        it { should_not have_content(text: "Leave this Group") }
      end

      describe "and is signed in" do
        before do
          sign_in user
          visit members_path(popular_group.id)
        end

        it { should have_selector('a', text: 'Join this Group' ) }

        describe "but is already a member" do
          before do
            popular_group.users << user
            visit members_path(popular_group.id)
          end

          it { should_not have_selector("a", text: join) }
          it { should have_selector("a", href: leave_path(popular_group.id)) }
          
          describe "submitting a POST request to the Groups#assign action" do
            before { post assign_path(popular_group.id) }
            
            specify { response.should redirect_to(members_path(popular_group.id)) }

            it "should not assign the user" do
              expect { post assign_path(popular_group.id) }.not_to change(Assignment, :count)
            end
          end
        end

        describe "and isn't a member yet" do
          
          it { should have_selector("a", text: join) }
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
  describe "when a user wants to leave a group" do
    let(:group) { FactoryGirl.create(:group, name: "Unique Group name") }
    let(:user) { FactoryGirl.create(:user) }
    let(:leave) { "Leave this Group" }
    before do
      group.users << user
      sign_in user
      visit members_path(group.id)
    end

    it { should have_selector("a", text: leave, href: leave_path(group.id)) }
    it "should unassign the user from the group" do
      expect { click_link leave }.to change(Assignment, :count).by(-1)
    end
    describe "after leave is pressed" do
      before { click_link leave }

      it { should have_selector('div.alert.alert-success',
                               text: 'You are no longer a member of this group') }
      it { should_not have_selector('div.alert.alert-error') }
    end
  end
end
