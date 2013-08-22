# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :integer
#  author_id  :integer
#  species    :string(255)
#

class Post < ActiveRecord::Base
  attr_accessible :species
  belongs_to :group
  belongs_to :author, class_name: "User"

  has_many   :comments, :contents

  before_save { |post| post.species = species.downcase }

  validates :group_id, presence: true
  validates :author_id, presence: true
  validates :species, presence: true

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
