# == Schema Information
#
# Table name: translations
#
#  id          :integer          not null, primary key
#  language    :string(2)
#  reference   :string(255)
#  translation :string(255)
#

require 'spec_helper'

describe Translation do

  before { @trans = Translation.new(language: "en", reference: "greeting", translation: "hello world") }

  subject { @trans }

  it { should respond_to(:language) }
  it { should respond_to(:refrence) }
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
end
