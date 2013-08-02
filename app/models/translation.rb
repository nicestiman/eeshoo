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

class Translation < ActiveRecord::Base
  attr_accessible :locale, :key, :value

  VALID_LANG_REGEX = /\A[a-z]{2}\z/

  validates :locale, presence: true, format: { with: VALID_LANG_REGEX }
  validates :key, presence: true
  validates :value, presence: true

  def self.lang_list
    languages = 
      Translation.select(:locale).uniq.collect do |trans|
        trans.locale
      end
  end
end
