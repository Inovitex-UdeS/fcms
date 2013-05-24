class RolesUser < ActiveRecord::Base

  # Associations marcos
  belongs_to :role
  belongs_to :user

  # Attributes
  attr_accessible :role_id, :user_id

end