class AddStartDateToEdition < ActiveRecord::Migration
  def change
      add_column :editions, :start_date, :date
  end
end
