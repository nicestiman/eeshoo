class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id]) 
    @group = Group.find(params[:group_id]) 
    if @group.users.include?(current_user) || current_user?(@post.author)
      @comment = @post.comments.new(params[:comment])
      if @post.save
        redirect_to group_post_path(@post.group.id, @post.id)
      else
        flash error: "could not post your comment"
        redirect_to group_post_path(@post.group.id, @post.id)
      end
    else
      redirect_to group_post_path(@post.group.id, @post.id)
    end 
  end
end
