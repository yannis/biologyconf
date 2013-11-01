class AddAttachmentPortraitToSpeakers < ActiveRecord::Migration
  def self.up
    change_table :speakers do |t|
      t.attachment :portrait
    end
  end

  def self.down
    drop_attached_file :speakers, :portrait
  end
end
