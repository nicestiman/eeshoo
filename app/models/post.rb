# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  content    :text
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :integer
#  author_id  :integer
#

class Post < ActiveRecord::Base
  attr_accessible :content, :title, :type
  belongs_to :group
  belongs_to :author, class_name: "User"

  has_many   :comments

  before_save { |post| post.type = type.downcase }

  validates :content, presence: true
  validates :title,   presence: true
  validates :group_id, presence: true
  validates :author_id, presence: true
  validates :type, presence: true

  def self.where_location(query)
    posts = []

    if query.include?(".")
      Post.all.each do |post|
        if post.group.location == query
          posts.push(post)
        end
      end
    else
      Post.all.each do |post|
        if post.group.location[0..1] == query
          posts.push(post)
        end
      end
    end
    
    return posts
  end
end
