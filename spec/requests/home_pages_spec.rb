require 'spec_helper'
## this is a collection of tests for the home page
describe "Home pages" do
  
  subject {page}
  
  describe "content", js: true do
    before {visit root_path}
    it{should have_content "HIWIPI"}
    it{should have_selector 'div', id: 'globe'}
    it{should have_selector 'div', id: 'story'}
    it{should have_selector 'svg'}
  end
end
