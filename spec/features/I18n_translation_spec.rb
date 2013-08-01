require 'spec_helper'

feature "I want to change the language" do
  before do
    #make a basic translation message
    @trans = FactoryGirl.create(:translation)
  end

  let(:language_prefs) { "en-US,en;q=0.8,pt-BR;q=0.6,pt;q=0.4" }

  subject { page }

  context "if I am using the query string" do
    before { visit signin_path + "?locale=en" }

    it "I should see the greeting in english" do
      page.should have_content(@trans.translation)
    end
  end
end
