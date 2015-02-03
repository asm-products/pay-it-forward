class FragmentsController < ApplicationController
  layout false
  
  def pledge_form
    @pledge_form = PledgeForm.new(ActiveSupport::JSON.decode(session[:pledge_form]).merge(user: current_user))
    
    respond_to do |format|
      format.html
      format.json
    end
  end
  
end
