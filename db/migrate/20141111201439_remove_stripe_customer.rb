class RemoveStripeCustomer < ActiveRecord::Migration
  def change
    drop_table :stripe_customers
    remove_column :stripe_charges, :stripe_customer_id
  end
end
