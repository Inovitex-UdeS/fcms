##
# This class represents the data from instruments table in database.
# Contains all the instruments in the application ('Guitare, Piano, ....')
class Instrument < ActiveRecord::Base

  ##
  # Instrument needs to have a unique name in order to create it
  #
  # @ return [String]
  validates :name, :presence => true, :uniqueness => true,  :length => { maximum: 64}

  ##
  # Get all the associated registration_users
  #
  # @ return [RegistrationUser]
  has_many :registrations_users

  ##
  # Get all the users playing this instruments
  #
  # @ return [User]
  has_many :users, :through => :registrations_users

  ##
  # Get all the registrations with this instrument in it
  #
  # @ return [Registration]
  has_many :registrations, :through => :registrations_users

end
