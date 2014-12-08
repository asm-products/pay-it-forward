class PledgesController < ApplicationController
  before_action :set_pledge, only: :show

  # GET /pledge/id
  def show
    session[:referrer_id] = @pledge.user_id if current_user.nil? || @pledge.user_id != current_user.id
  end

  # GET /pledge/new
  def new
    @pledge = Pledge.new(charity_id: params[:charity_id])
    
    redirect_to charities_path if @pledge.charity.nil?
  end

  # POST /pledge
  def create
    @pledge = CommitToPledge.call(pledge_params, user_params, current_user)

    respond_to do |format|
      if @pledge.save
        format.html { redirect_to @pledge }
      else
        format.html { render :new }
      end
    end
  end

  private

  def set_pledge
    @pledge = Pledge.find(params[:id])
  end

  def pledge_params
    params.require(:pledge).permit(:charity_id, :amount, :tip_percentage)
  end
  
  def user_params
    params.require(:user).permit(:stripe_customer_token, :name, :email)
  end
end