##
# This class represents the data from instruments table in database.
# Contains all the instruments in the application ('Guitare, Piano, ....')
class Instrument < ActiveRecord::Base

  ##
  # Model [Instrument] requires a unique length with a maximum of 64 characters
  #
  # @ return [String]
  validates :name, :presence => true, :uniqueness => true,  :length => { maximum: 64}

  ##
  # Get all the associated registration_users
  #
  # @ return [RegistrationUser]
  has_many :registrations_users

  ##
  # Get all the users playing this instrument
  #
  # @ return [User]
  has_many :users, :through => :registrations_users

  ##
  # Get all the registrations using this instrument
  #
  # @ return [Registration]
  has_many :registrations, :through => :registrations_users

end
