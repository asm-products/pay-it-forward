class ChangeTipPercentageToInteger < ActiveRecord::Migration
  def change
    change_column :pledges, :tip_percentage, :integer
  end
end
