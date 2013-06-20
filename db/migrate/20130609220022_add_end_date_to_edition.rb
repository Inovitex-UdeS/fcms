class AddEndDateToEdition < ActiveRecord::Migration
  def change
    add_column :editions, :end_date, :date
  end
end
