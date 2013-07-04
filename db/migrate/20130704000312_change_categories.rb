class ChangeCategories < ActiveRecord::Migration
  def up
  	change_table :categories do |t|
  		t.remove(:nb_perf_min)
  		t.remove(:nb_perf_max)
  		t.integer :nb_participants, :default=>1
  		t.boolean :accompanyist, :default=>false
  		t.integer :nb_piece_lim1
  		t.integer :nb_piece_lim2  
  	end
  end

  def down
  	change_table :categories do |t|
  		t.integer(:nb_perf_min)
  		t.integer(:nb_perf_max)
  		t.remove :nb_piece_lim1
  		t.remove :nb_piece_lim2  
  		t.remove :nb_participants, :default=>1
  		t.remove :accompanyist, :default=>false
  	end
  end
end
