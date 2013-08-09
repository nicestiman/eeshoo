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

require 'spec_helper'

describe Comment do
  before do 
    @group = Group.create(name: "Noodle Club", location: "US.CO")
    @author = @group.users.create(first: "Tom",last: "Billanger", email: "swagbag@hipster.fag", password: "password1", password_confirmation: "password1")
    @post = @group.posts.new(content: "coolest thing in the world this post is ", title:"coolest post ever", species: "default")
    @post.author = @author
    @post.save
    @comment = @post.comments.create(message: "this is a shityyyyy post") 
  end

  subject{@comment}
  
  it {should respond_to(:message)}

end
