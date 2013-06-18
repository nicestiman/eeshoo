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

    else
      render 'new'
    end
  end
end
