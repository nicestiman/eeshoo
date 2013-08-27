class PostsController < ApplicationController
  before_filter :signed_in_user, only: [:new, :create]
  before_filter :user_member_of_group, only: [:new, :create]
  before_filter :current_user_is_author, only: :destroy

  def new
    unless params[:species].nil?
      @species = Species.new(params[:species])
    else
      @species = Species.new("default")
    end
    @post = Post.new
    respond_to do |format|
      format.json
      format.html
    end
  end

  def show
    @group = Group.find(params[:group_id])
    @post = Post.find(params[:id])
    @species = Species.new(@post.species)
    @comments = @post.comments
    @comment = Comment.new()
    respond_to do |format|
      format.json
      format.html
    end
  end

  def destroy
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
    @post = @group.posts.new
    @post.author = current_user

    @post.species = params[:species]
    @species = Species.new(@post.species)

    @species.details.each do |field|
      unless params[:post][field["name"]].length > 0
        #@species = Species.new(@post.species)
        flash[:error] = "#{field["name"]} cannot be blank"
        render 'new'
        return
      end
    end

    if @post.save
      @species.details.each do |field|
        @post.contents.create(key: field["name"], value: params[:post][field["name"]])
      end
      redirect_to @group 
    else
      @species = Species.new(@post.species)
      render 'new'
    end
  end

  def tiered
    if params[:location].nil?
      @posts = Post.all
    else
      @posts = Post.where_location(params[:location])
    end
    respond_to do |format|
      format.json
    end
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
