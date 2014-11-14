class CommitToPledge
  def self.call(pledge_params, stripe_params, current_user)
    current_user ||= User.create_by_stripe!(stripe_params)
    current_user.register_stripe_customer(stripe_params) if current_user.stripe_customer.nil?

    pledge = Pledge.create!(pledge_params.merge(user_id: current_user.id))
    pledge.authorize!
    
    pledge
  end
end
