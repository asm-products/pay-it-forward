class AddUserToStripeCharge < ActiveRecord::Migration
  def change
    add_reference :stripe_charges, :user, index: true
  end
end
