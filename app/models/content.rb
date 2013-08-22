# == Schema Information
#
# Table name: contents
#
#  id         :integer          not null, primary key
#  post_id    :integer
#  key        :string(255)
#  value      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Content < ActiveRecord::Base
   attr_accessible :key, :value

   belongs_to :post

   validates :key, presence: true
end
