class ChangeColumnNameAccompanyist < ActiveRecord::Migration
  def up
  	rename_column :categories, :accompanyist, :accompanist
  end

  def down
  	rename_column :categories, :accompanist, :accompanyist
  end
end
