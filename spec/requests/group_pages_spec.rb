require 'spec_helper'

describe "Group pages" do
  subject { page }

  describe "new group page" do
    before { visit new_group_path }

    it { should have_selector "title", text: "New Group" }
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
end
