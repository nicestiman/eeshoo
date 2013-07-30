# == Schema Information
#
# Table name: translations
#
#  id          :integer          not null, primary key
#  language    :string(2)
#  reference   :string(255)
#  translation :string(255)
#

class Translation < ActiveRecord::Base
  attr_accessible :language, :reference, :translation

  VALID_LANG_REGEX = /\A[a-z]{2}\z/

  validates :language, presence: true, format: { with: VALID_LANG_REGEX }
  validates :reference, presence: true
  validates :translation, presence: true
end
