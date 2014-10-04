class AddAttachmentImageToCharities < ActiveRecord::Migration
  def self.up
    change_table :charities do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :charities, :image
  end
end
