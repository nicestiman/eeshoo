require 'spec_helper'

feature "As a new user I want to get a welcome email." do 
  before do 
    @user = FactoryGirl.build(:user)
    register @user 
  end
  
  it{ActionMailer::Base.deliveries.should_not be_empty}
end
