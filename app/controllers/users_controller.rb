class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /user
  def show
  end

  # GET /user/new
  def new
    @user = User.new
  end

  # GET /user/edit
  def edit
  end

  # POST /user
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to :root, notice: 'User was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /users
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to :root, notice: 'User was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  private
  
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
