class UserSessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    if @user = login(session_params[:email], session_params[:password])
      redirect_back_or_to(:root, notice: 'Sign in successful')
    else
      flash.now[:alert] = 'Sign in failed'
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_back_or_to(:root, notice: 'Signed out!')
  end

  private

  def session_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
