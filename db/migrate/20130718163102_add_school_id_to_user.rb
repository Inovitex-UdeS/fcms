class AddSchoolIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :school_id, :integer, :default => '1'
    add_foreign_key(:users, :schools)
  end
end