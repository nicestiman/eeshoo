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

  before { @trans = Translation.new(language: "en", reference: "greeting", translation: "hello world") }

  subject { @trans }

  it { should respond_to(:language) }
  it { should respond_to(:reference) }
  it { should respond_to(:translation) }

  it { should be_valid }

  #tests for presence
  describe "when language is not defined" do
    before { @trans.language = " " }
    it { should_not be_valid }
  end

  describe "when reference key is not defined" do
    before { @trans.reference = " " }
    it { should_not be_valid }
  end

  describe "when translation is not provided" do
    before { @trans.translation = " " }
    it { should_not be_valid }
  end

  #tests for format
  describe "when language format is invalid" do
    it "should not be valid" do
      languages = %w[eM en. En. en-gb en-GB en- hjasdvjfnjnjklusfhusfhsdfhj]

      languages.each do |invalid_lang|
        @trans.language = invalid_lang
        @trans.should_not be_valid
      end
    end
  end

  describe "when language format is valid" do
    it "should be valid" do
      languages = %w[en pt ch]

      languages.each do |valid_lang|
        @trans.language = valid_lang
        @trans.should be_valid
      end
    end
  end

  describe "lang_list should return all the languages" do
    before do
      @trans.save
      Translation.create(language: "en", reference: "second_trans", translation: "whazzup")
      Translation.create(language: "pt", reference: "third_trans", translation: "e ai meu filho?")
    end

    it "should list the available languages" do
      expect(Translation.lang_list.include?("en")).to eq(true)
      expect(Translation.lang_list.include?("pt")).to eq(true)
      expect(Translation.lang_list.count).to eq(2)
    end
  end
end
