class AddStripeChargeIdToPledges < ActiveRecord::Migration
  def change
    add_column :pledges, :stripe_charge_id, :string
  end
end
