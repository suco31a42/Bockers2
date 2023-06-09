class GroupUsersController < ApplicationController
  before_action :authenticate_user!

  def create
    @book = Book.new
    @group = Group.find(params[:group_id])
    @group_user = current_user.group_users.new(group_id: params[:group_id])
    @group_user.save
    render :create
  end

  def destroy
    @book = Book.new
    @group = Group.find(params[:group_id])
    @group_user = current_user.group_users.find_by(group_id: params[:group_id])
    @group_user.destroy
    render :destroy
  end
end
