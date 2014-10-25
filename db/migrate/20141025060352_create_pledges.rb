class CreatePledges < ActiveRecord::Migration
  def change
    create_table :pledges do |t|
      t.belongs_to :referrer, index: true
      t.belongs_to :user, index: true
      t.integer :action
      t.timestamp :expiration

      t.timestamps null: false
    end
  end
end
