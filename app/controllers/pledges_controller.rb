class PledgesController < ApplicationController
  skip_load_and_authorize_resource
  skip_authorization_check
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
    @pledge = CommitToPledge.call(pledge_params, stripe_params, current_user)

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
    params.require(:pledge).permit(:charity_id, :tip_percentage, :amount)
  end

  def stripe_params
    ActionController::Parameters.new(
      token: params[:stripeToken],
      token_type: params[:stripeTokenType],
      email: params[:stripeEmail]
      )
  end
end
