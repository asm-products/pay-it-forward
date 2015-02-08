class FragmentsController < ApplicationController
  layout false

  def pledge_form
    @pledge_form = PledgeForm.new(ActiveSupport::JSON.decode(session[:pledge_form]).merge(user: current_user))
    @pledge_form.tip_percentage ||= 5
    @pledge_form.amount ||= 2000

    respond_to do |format|
      format.html
      format.json
    end
  end
end
