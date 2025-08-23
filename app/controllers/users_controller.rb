class UsersController < ApplicationController
  before_action :authenticate_user!


  def index
    users = User.where.not(id: current_user.id).select(:id, :email, :display_name)
    render json: users
  end
end
