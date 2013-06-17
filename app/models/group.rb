class Group < ActiveRecord::Base
  attr_accessible :location, :name

  validates :name, presence: true

  validates :location, presence: true
end
