require 'spec_helper'

describe "User Pages" do

  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1', text: 'Sign up') }
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

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
end
