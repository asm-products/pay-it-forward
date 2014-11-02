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
    @pledge_candidate.assign_attributes(pledge_candidate_params.merge(current_step: step))
    render_wizard encode_pledge_candidate
  end

  private

  def decode_pledge_candidate
    @pledge_candidate = PledgeCandidate.new(ActiveSupport::JSON.decode(session[:pledge_candidate] || '{}'))
  end

  def encode_pledge_candidate
    session[:pledge_candidate] = ActiveSupport::JSON.encode(@pledge_candidate) if @pledge_candidate.valid?
    @pledge_candidate
  end

  def pledge_candidate_params
    params.require(:pledge_candidate).permit(:referrer_id, :charity_id, :tip_percentage)
  end
end
