class PostsController < ApplicationController
  def new
    @post = Post.new
    respond_to do |format|
      format.json
      format.html
    end
  end

  def show
    respond_to do |format|
      format.json
      format.html
    end
  end

  def index
    @group = Group.find(params[:group_id])
    @posts = @group.posts
    respond_to do |format|
      format.json
    end
  end

  def create
    @group = Group.find(params[:group_id])
    @post = @group.posts.new(params[:post])

    if @post.save
      redirect_to @post
    else
      render 'new'
    end
  end
end
