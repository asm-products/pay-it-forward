class CreateStripeCharges < ActiveRecord::Migration
  def change
    create_table :stripe_charges do |t|
      t.string :stripe_id
      t.belongs_to :stripe_customer, index: true
      t.integer :value
      t.string :currency
      t.integer :status

      t.timestamps null: false
    end
  end
end
