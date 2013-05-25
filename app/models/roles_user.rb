class RolesUser < ActiveRecord::Base

  # Associations marcos
  belongs_to :role
  belongs_to :user

end