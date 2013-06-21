# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  first      :string(255)
#  last       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :email, :first, :last

  validates :email, presence: true
  validates :first, presence: true, length: { maximum: 30 }
  validates :last, presence: true, length: { maximum: 30 }
end
