class DropStatusFromePledge < ActiveRecord::Migration
  def change
    remove_column :pledges, :status
  end
end
