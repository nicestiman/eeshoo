require 'spec_helper'

feature "I want to change the language" do
  let(:english) { "Sign in" }
  let(:portuguese) { "Enscrever" }

  context "if I am using the query string for english" do
    before do
      visit groups_path
      visit signin_path + "?locale=en" 
    end

    scenario "I should see the greeting in english" do
      page.should have_selector("h1", text: english)
      page.should_not have_content("translation missing")
    end
  end

  context "if I am not using anything" do
    before do
      visit groups_path
      visit signin_path
    end

    scenario "I should see the greeting in english" do
      page.should_not have_content("translation missing")
      page.should have_selector("h1", text: english)
    end
  end

  context "if I am using a language that is not supported" do
    context "via the query string" do
      before do
        visit groups_path
        visit signin_path + "?locale=wk"
      end

      scenario "I should see the greeting in the default language" do
        page.should_not have_content("translation missing")
        page.should have_selector("h1", text: english)
      end
    end

    context "via a http header", js: true do
      before do
        visit groups_path
        page.driver.headers = { 'ACCEPT-LANGUAGE' => 'wk' }
        visit signin_path
      end

      scenario "I should see the greeting in the default language" do
        page.should_not have_content("translation missing")
        page.should have_selector("h1", text: english)
      end
    end
  end

  context "if I am using a query string for portuguese" do
    before do
      visit groups_path
      visit signin_path + "?locale=pt"
    end

    scenario "I should see the greeting in portuguese" do
      page.should_not have_content("translation missing")
      page.should have_selector("h1", text: portuguese)
    end
  end

  context "if I am using a http header for portuguese", js: true do
    before do
      visit groups_path
      page.driver.headers = { 'ACCEPT-LANGUAGE' => 'pt' }
      visit signin_path
    end

    scenario "I should see the greeting in portuguese" do
      page.should_not have_content("translation missing")
      page.should have_selector("h1", text: portuguese)
    end
  end
end
