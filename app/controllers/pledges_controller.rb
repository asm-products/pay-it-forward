class PledgesController < ApplicationController
  skip_load_and_authorize_resource
  skip_authorization_check
  before_action :decode_pledge_candidate, only: [:show, :update, :create]
  
  include Wicked::Wizard
  steps :select_charity, :set_value

  # GET /pledge/new
  def new
    redirect_to wizard_path(steps.first)
  end
  
  # GET /pledge/:step
  def show
    render_wizard
  end
  
  def update
    render_wizard
  end
  
  private
  
  def decode_pledge_candidate
    @pledge_candidate = PledgeCandidate.new(ActiveSupport::JSON.decode(session[:pledge_candidate] || '{}'))
  end
  
  def encode_pledge_candidate
    session[:pledge_candidate] = ActiveSupport::JSON.encode(@pledge_candidate)
  end
  
  def pledge_params
    params.require(:pledge).permit(:referrer_id, :charity_id, :tip_percentage) unless params[:pledge].nil?
  end
end
