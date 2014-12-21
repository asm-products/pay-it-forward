class AddPledgeToStripeCharge < ActiveRecord::Migration
  def change
    add_reference :stripe_charges, :pledge, index: true
  end
end
