require 'spec_helper'

feature "I want to change the language" do
  before(:all) do
    @english_trans = FactoryGirl.create(:translation)
    @portuguese_trans = FactoryGirl.create(:translation, locale: "pt", value: "Enscrever")
  end

  after(:all) do
    Translation.delete_all
  end

  context "if I am using the query string for english" do
    before do
      visit signin_path + "?locale=en" 
    end

    it "I should see the greeting in english" do
      save_and_open_page
      page.should have_selector("h1", text: @english_trans.value)
      page.should_not have_content("translation missing")
    end
  end

  context "if I am using the query string for portuguese" do
    before do
      visit signin_path + "?locale=pt"
    end

    it "I should see the greeting in portuguese" do
      page.should_not have_content("translation missing")
      page.should have_selector("h1", text: @portuguese_trans.value)
    end
  end

  context "if I am not using anything" do
   before do
     visit signin_path
   end

   it "I should see the greeting in english" do
     page.should_not have_content("translation missing")
     page.should have_selector("h1", text: @english_trans.value)
   end
  end

  context "if I am using a language that is not supported" do
    context "via the query string" do
      before do
        visit signin_path + "?locale=wk"
      end

      it "I should see the greeting in the default language" do
        page.should_not have_content("translation missing")
        page.should have_selector("h1", text: @english_trans.value)
      end
    end

    context "via a http header", js: true do
      before do
        page.driver.headers = { 'ACCEPT-LANGUAGE' => 'wk' }
        visit signin_path
      end

      it "I should see the greeting in the default language" do
        page.should_not have_content("translation missing")
        page.should have_selector("h1", text: @english_trans.value)
      end
    end
  end
end
