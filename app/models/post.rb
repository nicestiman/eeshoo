# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :integer
#

class Post < ActiveRecord::Base
  attr_accessible :content, :title
  belongs_to :group

  validates :content, presence: true
  validates :title,   presence: true
  validates :group_id, presence: true
end
