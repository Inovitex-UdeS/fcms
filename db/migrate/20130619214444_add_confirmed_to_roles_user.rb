class AddConfirmedToRolesUser < ActiveRecord::Migration
  def change
  	add_column :roles_users, :confirmed, :boolean, :default =>false
  end
end
