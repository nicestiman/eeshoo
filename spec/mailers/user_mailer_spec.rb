require "spec_helper"

describe UserMailer do
  describe "welcome email" do
    let (:user) { FactoryGirl.create(:user)}
    let (:mail) { UserMailer.welcome_email(user)}

    it "renders the subject" do
      mail.subject.should == 'welcome'
    end

    it "renders the from" do
      mail.from.should_not be_empty
    end
  end
end
