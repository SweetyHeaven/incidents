class RenameTypeField < ActiveRecord::Migration
  def up
  	rename_column :incidents, :type, :incident_type
  end

  def down
  end
end
