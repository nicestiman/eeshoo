class GroupsController < ApplicationController
  def new
    @group = Group.new
  end

  def index
    @groups = Group.all
    respond_to do |format|
      format.json
    end
  end

  def create
    @group = Group.new(params[:group])
    if @group.save
      flash[:success] = "Group updated"
      redirect_to @group
    else
      render 'new'
    end
  end

  def show
    @group = Group.find(params[:id])
  end

  def user_index
    @group = Group.find(params[:id])
    @users = @group.users
  end

  def assign_user
    @group = Group.find(params[:id])
    if @group.users.include?(current_user)
      flash[:notice] = "You are already a member of this group"
      redirect_to(members_path(@group.id))
    else
      @group.users << current_user
      flash[:success] = "You have successfully joined this group"
      redirect_to(members_path(@group.id))
    end
  end
end
