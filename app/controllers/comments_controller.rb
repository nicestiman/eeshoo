class CommentsController < ApplicationController
  def create
    logger.debug "params sent from server: "+params.to_json
    @post = Post.find(params[:post_id]) 
    @comment = @post.comments.new(params[:comment])
    @post.save
    redirect_to group_post_path(@post.group.id, @post.id)
  end
end
