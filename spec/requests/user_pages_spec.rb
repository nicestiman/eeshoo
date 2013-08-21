require 'spec_helper'

describe "User Pages" do

  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1', text: 'Sign up') }
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit user_path(user) 
    end

    it { should have_selector('h1', text: user.first) }
    it { should have_selector('h1', text: user.last)  }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_content "error" }
      end
    end

    describe "with valid information" do
      before do
        fill_in "First",        with: "Jane"
        fill_in "Last",         with: "Doe"
        fill_in "Email",        with: "test@example.com"
        fill_in "Password",     with: "testPass"
        fill_in "Confirmation", with: "testPass"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_selector('h1',     text: "Update Profile") }
      it { should have_selector('title',  text: "Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save Changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_first_name)  { "New" }
      let(:new_last_name)   { "Name" }
      let(:new_email)       { "new@example.com" }
      before do
        fill_in "First",        with: new_first_name
        fill_in "Last",         with: new_last_name
        fill_in "Email",        with: new_email
        fill_in "Password",     with: user.password
        fill_in "Confirmation", with: user.password
        click_button "Save Changes"
      end

      it { should have_selector('title', text: new_first_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.first.should  ==  new_first_name }
      specify { user.reload.last.should   ==  new_last_name }
      specify { user.reload.email.should  ==  new_email }
    end
  end
end
