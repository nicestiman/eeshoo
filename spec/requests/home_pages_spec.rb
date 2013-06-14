require 'spec_helper'
## this is a collection of tests for the home page
describe "Home pages" do
  
  subject {page}
  
  describe "content" do
    before {visit root_path}
    it{should have_content "HIWIPI"}
    it{should have_selector 'div', id: 'globe'}
  end
end
