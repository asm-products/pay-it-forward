class AddCharityAndTipPercentageToPledges < ActiveRecord::Migration
  def change
    add_reference :pledges, :charity, index: true
    add_column :pledges, :tip_percentage, :decimal
  end
end
