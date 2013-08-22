class Content < ActiveRecord::Base
   attr_accessible :key, :value

   belongs_to :post

   validates :key, presence: true
end
