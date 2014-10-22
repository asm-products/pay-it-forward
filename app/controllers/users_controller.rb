class UsersController < ApplicationController
  load_and_authorize_resource

  before_action :set_user, only: [:show]
  before_action :set_current_user, only: [:finish_sign_up]

  # GET/PATCH /users/:id
  def show
  end

  # GET/PATCH /users/finish_sign_up
  def finish_sign_up
    # TODO: Redirect if no current_user, or sign up finished
    respond_to do |format|
      if request.patch? && @user.finish_sign_up(user_params)
        format.html { redirect_to @user, notice: 'Your profile was successfully updated.' }
      else
        format.html
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def set_current_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:email)
  end
end
