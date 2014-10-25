class CreateStripeCustomers < ActiveRecord::Migration
  def change
    create_table :stripe_customers do |t|
      t.string :stripe_id
      t.belongs_to :user, index: true

      t.timestamps null: false
    end
  end
end
