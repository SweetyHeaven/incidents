class AddFirstNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :score, :integer, :default => 0
    add_column :users, :role, :string, :default => "Employee"
  end
end
