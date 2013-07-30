##
# This class represents the data from roles_users table in database.
# Association table between [Role] ans [User]
class RolesUser < ActiveRecord::Base

  ##
  # Get the role out of this association
  #
  # @ return [Role]
  belongs_to :role

  ##
  # Get the user out of this association
  #
  # @ return [User]
  belongs_to :user

end