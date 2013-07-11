class GroupsController < ApplicationController
  def new
    @group = Group.new
  end

  def index
    @groups = Group.all
    respond_to do |format|
      format.json
      format.html
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
      redirect_back_or(members_path(@group.id))
    end
  end

  def remove_user
    @group = Group.find(params[:id])
    if @group.users.include?(current_user)
      if @group.remove(current_user)
        flash[:success] = "You are no longer a member of this group"
        redirect_to(members_path(@group.id))
      else
        flash[:error] = "There was an error leaving the group"
        redirect_to(members_path(@group.id))
      end
    end
  end
end
