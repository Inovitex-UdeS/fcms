class ChangeAgesInAgegroup < ActiveRecord::Migration
  def self.up
  	change_table :agegroups do |t|
  		t.remove(:min)
  		t.remove(:max)
  		t.integer :min
  		t.integer :max  
  	end
  end

  def self.down 
  	change_table :agegroups do |t|
  		t.remove(:min)
  		t.remove(:max)
  		t.date :min
  		t.date :max  
  	end
  end
end
