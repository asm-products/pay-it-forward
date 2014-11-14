class AddCharityIdToPledges < ActiveRecord::Migration
  def change
    add_reference :pledges, :charity, index: true
  end
end
