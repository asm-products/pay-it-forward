class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :finish_signup]

  # GET /users/1
  def show
    # authorize! :read, @user
  end

  # GET /users/1/edit
  def edit
    # authorize! :update, @user
  end

  # PATCH/PUT /users/1
  def update
    # authorize! :update, @user
    respond_to do |format|
      if @user.update(user_params)
        sign_in(@user == current_user ? @user : current_user, bypass: true)
        format.html { redirect_to @user, notice: 'Your profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET/PATCH /users/1/finish_signup
  def finish_signup
    # authorize! :update, @user
    if request.patch? && params[:user] # && params[:user][:email]
      if @user.update(user_params)
        @user.skip_reconfirmation!
        sign_in(@user, bypass: true)
        redirect_to @user, notice: 'Your profile was successfully updated.'
      else
        @show_errors = true
      end
    end
  end

  private
  
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    accessible = [:name, :email]
    accessible << [:password, :password_confirmation] unless params[:user][:password].blank?
    params.require(:user).permit(accessible)
  end
end
