class PledgesController < ApplicationController
  before_action :set_pledge, only: :show

  # GET /pledge/id
  def show
    # session[:referrer_id] = # pledge of other user
  end

  # GET /pledge/new
  def new
    charity = Charity.find_by_id(params[:charity_id])
    redirect_to charities_path if charity.nil?

    @pledge_form = PledgeForm.new(charity: charity, user: current_user)
  end

  # POST /pledge
  def create
    @pledge_form = PledgeForm.new(pledge_form_params.merge(user: current_user))

    respond_to do |format|
      if @pledge_form.save
        format.html { redirect_to @pledge_form.pledge }
      else
        format.html { render :new }
      end
    end
  end

  private

  def set_pledge
    @pledge = Pledge.find(params[:id])
  end

  def pledge_form_params
    params.require(:pledge_form).permit(:charity_id, :amount, :tip_percentage, :stripe_auth_token, :name, :email)
  end
end
