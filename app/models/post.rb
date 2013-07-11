# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  content    :text(255)
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :integer
#  author_id  :integer
#

class Post < ActiveRecord::Base
  attr_accessible :content, :title
  belongs_to :group
  belongs_to :author, class_name: "User"

  validates :content, presence: true
  validates :title,   presence: true
  validates :group_id, presence: true
end
