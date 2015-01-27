class FragmentsController < ApplicationController
  layout false
  
  def pledge_form
    @pledge_form = PledgeForm.new(charity: Charity.find(1), user: current_user)
    
    respond_to do |format|
      format.html
      format.json
    end
  end
  
end
