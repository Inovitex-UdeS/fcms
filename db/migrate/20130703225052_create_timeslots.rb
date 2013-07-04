class CreateTimeslots < ActiveRecord::Migration
  def change
    create_table :timeslots, :force => true do |t|  
    	t.string   "label",			:null => false
    	t.integer  "edition_id", 	:null => false
    	t.integer  "category_id", 	:null => false
    	t.integer  "duration", 		:null => false
    	t.timestamps
    end
   add_index :timeslots, ["id"], :name => "timeslots_pk", :unique => true  
   add_index :timeslots, ["edition_id"], :name => "edition_id_fk3"
   
   add_foreign_key :timeslots, "editions", :name => "fk_timeslot_edition", :dependent => :restrict 
   add_foreign_key(:timeslots, :categories)
  end
end
