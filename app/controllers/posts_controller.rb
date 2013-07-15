class PostsController < ApplicationController
  before_filter :signed_in_user, only: [:new, :create]
  before_filter :user_member_of_group, only: [:new, :create]

  def new
    @post = Post.new
    respond_to do |format|
      format.json
      format.html
    end
  end

  def show
    @group = Group.find(params[:group_id])
    @post = Post.find(params[:id])
    respond_to do |format|
      format.json
      format.html
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.delete
    redirect_to group_path(params[:group_id])
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
    @post.author = current_user
    
    if @post.save
      redirect_to @group 
    else
      render 'new'
    end
  end

  def tiered
    @posts = Post.all
  end

  private
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def user_member_of_group
      @group = Group.find(params[:group_id])
      unless @group.users.include?(current_user)
        store_location
        redirect_to members_path(@group.id), notice: "Please join the group to add a post"
      end
    end

    def current_user_is_author
      @post = Post.find(params[:id])
      unless current_user?(@post.author)
        redirect_to group_post_path(params[:group_id], @post.id), 
          notice: "You are not authorized to delete this post"
      end
    end
end
