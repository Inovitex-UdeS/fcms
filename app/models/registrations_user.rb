##
# This class represents the data from registrations_users table in database.
# Association table between [Registration] ans [User]
class RegistrationsUser < ActiveRecord::Base

  ##
  # All the columns are required in order to create a [RegistrationsUser]
  #
  # @ return [Integer]
  validates :instrument_id, :registration_id, :user_id, :presence => true

  ##
  # Directly get the instrument
  #
  # @ return [Instrument]
  belongs_to :instrument

  ##
  # Directly get the registration
  #
  # @ return [Registration]
  belongs_to :registration

  ##
  # Directly get the user
  #
  # @ return [User]
  belongs_to :user

end
