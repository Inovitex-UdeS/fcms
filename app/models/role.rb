class Role < ActiveRecord::Base
  attr_accessible :id, :name


  # For Authorizations
  self.table_name = 'role'
  has_and_belongs_to_many :user , :join_table => :userrole
end
