# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  message    :string(255)
#  post_id    :integer
#  author_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Comment < ActiveRecord::Base
  attr_accessible :message
  belongs_to :post
  belongs_to :auther, class_name: "User"

end
