##
# This class represents the data from roles table in database.
# Contains all the roles in the application ('Administrateur, Juge, Accompagnateur, Participant, Professeur')
class Role < ActiveRecord::Base
  ##
  # Name of the role is require and need to be unique in order to create it
  #
  # @ return [String]
  validates :name, :presence => true, :length => { :maximum => 128}, :uniqueness => true

  ##
  # Association table to map [User] and [Registration]
  #
  # @ return [RolesUser]
  has_many :roles_users

  ##
  # Users associated with the role
  #
  # @ return [User]
  has_many :users, :through => :roles_users # For authorizations
end
