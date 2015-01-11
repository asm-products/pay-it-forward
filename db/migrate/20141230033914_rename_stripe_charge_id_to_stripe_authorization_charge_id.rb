class RenameStripeChargeIdToStripeAuthorizationChargeId < ActiveRecord::Migration
  def change
    rename_column :pledges, :stripe_charge_id, :stripe_authorization_charge_id
  end
end
