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
    @posts = Post.all
    respond_to do |format|
      format.json
    end
  end
end
