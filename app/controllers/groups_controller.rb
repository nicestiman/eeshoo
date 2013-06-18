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
  end
end
