class AddUserAccompanistToRegistration < ActiveRecord::Migration 
  def change
  
  	add_column :registrations, :user_accompanist_id, :integer 
  	add_index "registrations", "user_accompanist_id" 
  	add_foreign_key :registrations, :users, :name => "fk_registration_accompanist" , :column => "user_accompanist_id" 
  end 
end
