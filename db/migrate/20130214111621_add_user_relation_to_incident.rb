class AddUserRelationToIncident < ActiveRecord::Migration
  def change
    change_table :incidents do |t|
      t.references :creator
      t.references :assigned_to
    end
  end
end
