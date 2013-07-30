##
# NOT IMPLEMENTED
# This class represents the data from payments table in database.
# Contains all the payments from all the registrations
class Payment < ActiveRecord::Base

  ##
  # Get the associated registration
  #
  # @ return [Registration]
  belongs_to :registration

  ##
  # Get the associated user
  #
  # @ return [User]
  belongs_to :user

end
