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
      redirect_to @group
    else
      render 'new'
    end
  end

  def show
    @group = Group.find(params[:id])
  end
end
