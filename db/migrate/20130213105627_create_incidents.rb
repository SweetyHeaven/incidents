class CreateIncidents < ActiveRecord::Migration
  def change
    create_table :incidents do |t|
      t.string :info
      t.integer :type , :limit => 1
      t.integer :score , :default => 5

      t.timestamps
    end
  end
end
