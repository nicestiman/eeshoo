require 'spec_helper'

feature "I want to change the language" do
  let(:language_prefs) { "en-US,en;q=0.8,pt-BR;q=0.6,pt;q=0.4" }

  subject { page }

  context "if I am using the query string" do
    context "for english" do
      let(:trans) { FactoryGirl.create(:translation) }
      before do
        visit signin_path + "?locale=en" 
      end

      it "I should see the greeting in english" do
        page.should have_selector("h1", text: trans.value)
      end
    end

    context "for portuguese" do
      let(:trans) { FactoryGirl.create(:translation, locale: "pt", value: "Enscrever") }
      before do
        visit signin_path + "?locale=pt"
      end

      it "I should see the greeting in portuguese" do
        page.should have_selector("h1", text: trans.value)
      end
    end
  end
end
