class RemoveStripeCharge < ActiveRecord::Migration
  def change
    drop_table :stripe_charges
    add_column :pledges, :stripe_charge_id, :string
    add_column :pledges, :status, :integer
    remove_column :pledges, :charity_id
  end
end