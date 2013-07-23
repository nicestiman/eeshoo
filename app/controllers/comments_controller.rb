class CommentsController < ApplicationController
  def create 
    @post = Post.find(params[:post_id]) 
    @comment = @post.comments.new(prams[:post])
    @post.save
    redirect_to @post
  end
end
