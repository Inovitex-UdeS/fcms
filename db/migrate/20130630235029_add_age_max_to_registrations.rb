class AddAgeMaxToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :age_max, :integer
  end
end
