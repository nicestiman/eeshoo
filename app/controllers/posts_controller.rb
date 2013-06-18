class PostsController < ApplicationController
  def new
    @group = Group.find(params[:group_id])
    @post = @group.posts.new
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
    render 'new'
  end
end
