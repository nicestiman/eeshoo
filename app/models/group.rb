# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  location   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Group < ActiveRecord::Base
  attr_accessible :location, :name
  has_many :posts
  
  has_many :assignments
  has_many :users, :through => :assignments

  validates :name, presence: true, length: { maximum: 40 }
  validates :location, presence: true
end
