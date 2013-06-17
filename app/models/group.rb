class Group < ActiveRecord::Base
  attr_accessible :location, :name

  validates :name, presence: true, length: { maximum: 40 }

  validates :location, presence: true
end
