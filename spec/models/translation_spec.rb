# == Schema Information
#
# Table name: translations
#
#  id             :integer          not null, primary key
#  locale         :string(255)
#  key            :string(255)
#  value          :text
#  interpolations :text
#  is_proc        :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'spec_helper'

describe Translation do

  before { @trans = FactoryGirl.build(:translation) }

  subject { @trans }

  it { should respond_to(:locale) }
  it { should respond_to(:key) }
  it { should respond_to(:value) }

  it { should be_valid }

  #tests for presence
  describe "when locale is not defined" do
    before { @trans.locale = " " }
    it { should_not be_valid }
  end

  describe "when key is not defined" do
    before { @trans.key = " " }
    it { should_not be_valid }
  end

  describe "when value is not provided" do
    before { @trans.value = " " }
    it { should_not be_valid }
  end

  #tests for format
  describe "when language format is invalid" do
    it "should not be valid" do
      languages = %w[eM en. En. en-gb en-GB en- hjasdvjfnjnjklusfhusfhsdfhj]

      languages.each do |invalid_lang|
        @trans.locale = invalid_lang
        @trans.should_not be_valid
      end
    end
  end

  describe "when language format is valid" do
    it "should be valid" do
      languages = %w[en pt ch]

      languages.each do |valid_lang|
        @trans.locale = valid_lang
        @trans.should be_valid
      end
    end
  end

  describe "lang_list should return all the languages" do
    before do
      @trans.save
      FactoryGirl.create(:translation, key: "second_translation", value: "whazzup?")
      FactoryGirl.create(:translation, locale: "pt", value: "e ai meu filho?")
    end

    it "should have valid translations" do
      expect(Translation.count).to eq(3)
    end

    it "should list the available languages" do
      expect(Translation.lang_list.count).to eq(2)
      expect(Translation.lang_list.include?('pt')).to eq(true)
      expect(Translation.lang_list.include?("en")).to eq(true)
    end
  end
end
