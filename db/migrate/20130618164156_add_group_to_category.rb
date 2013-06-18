class AddGroupToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :group, :boolean, :default =>false
  end
end
