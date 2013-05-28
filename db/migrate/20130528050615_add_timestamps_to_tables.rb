class AddTimestampsToTables < ActiveRecord::Migration
  def change
    add_timestamps(:agegroups)
    add_timestamps(:categories)
    add_timestamps(:cities)
    add_timestamps(:composers)
    add_timestamps(:contactinfos)
    add_timestamps(:editions)
    add_timestamps(:instruments)
    add_timestamps(:payments)
    add_timestamps(:performances)
    add_timestamps(:pieces)
    add_timestamps(:registrations)
    add_timestamps(:registrations_users)
    add_timestamps(:roles)
    add_timestamps(:roles_users)
    add_timestamps(:schoolboards)
    add_timestamps(:schools)
    add_timestamps(:schooltypes)
    add_timestamps(:users)
  end
end
