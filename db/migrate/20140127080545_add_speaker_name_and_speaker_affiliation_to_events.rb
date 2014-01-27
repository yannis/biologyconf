class AddSpeakerNameAndSpeakerAffiliationToEvents < ActiveRecord::Migration
  def change
    add_column :events, :speaker_name, :string
    add_column :events, :speaker_affiliation, :string
  end
end
