class PledgesController < ApplicationController
  load_and_authorize_resource
  before_action :set_pledge, only: [:show]

  # GET /pledge/new
  def new
    @charity = Pledge.new
  end

  # POST /charities
  def create
    @pledge = Pledge.new(pledge_params)

    respond_to do |format|
      if @pledge.save
        format.html { redirect_to @pledge, notice: 'Pledge was successfully created.' }
        format.json { render :show, status: :created, location: @pledge }
      else
        format.html { render :new }
        format.json { render json: @pledge.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private

  def set_pledges
    @pledge = Pledge.find(params[:id])
  end

  def pledge_params
    params.require(:pledge).permit(:name, :description, :url, :image)
  end
end