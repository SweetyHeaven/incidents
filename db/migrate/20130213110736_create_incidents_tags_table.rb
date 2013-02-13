class CreateIncidentsTagsTable < ActiveRecord::Migration
  def up
  	create_table :incidents_tags, :id => false do |t|
        t.references :incident
        t.references :tag
    end
    add_index :incidents_tags, [:incident_id, :tag_id]
    add_index :incidents_tags, [:tag_id, :incident_id]
  end

  def down
 	drop_table :incidents_tags
  end
end
