class AddStateToPledge < ActiveRecord::Migration
  def change
    add_column :pledges, :state, :integer
  end
end
