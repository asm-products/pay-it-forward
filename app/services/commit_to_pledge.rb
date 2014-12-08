class CommitToPledge
  def self.call(pledge_params, user_params, current_user)
    current_user ||= User.create_by_pledge_user_params!(user_params)
    
    if current_user.stripe_customer.nil?
      current_user.register_stripe_customer(user_params[:stripe_customer_token])
      current_user.save!
    end

    pledge = Pledge.create!(pledge_params.merge(user_id: current_user.id))
    pledge.authorize!

    pledge
  end
end
