class AddEditLimitDateToEditions < ActiveRecord::Migration
  def change
    add_column :editions, :edit_limit_date, :date
  end
end
