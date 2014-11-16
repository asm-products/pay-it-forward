class AddNameAndStripeCustomerIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :stripe_customer_id, :string
  end
end
