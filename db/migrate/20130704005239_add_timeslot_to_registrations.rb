class AddTimeslotToRegistrations < ActiveRecord::Migration
  def change
  	add_column :registrations, :timeslot_id, :integer
  	add_foreign_key(:registrations, :timeslots)

  end
end
