require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_selector('title',  text: 'Sign in') }
      it { should have_content(text: 'Invalid') }

      describe "with valid information" do
        let(:user) { FactoryGirl.create(:user) }
        before { sign_in user }

        it { should have_selector('title', text: user.name) }
        it { should have_link('Sign out', href: signout_path) }
        
        it { should_not have_link('Sign in', href: signin_path) }
      end
    end
  end
end
