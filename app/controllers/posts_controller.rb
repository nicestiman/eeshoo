class PostsController < ApplicationController
  def new
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
end
