##
# This class represents the data from editions table in database.
# Contains all the editions in the application ('2008, 2009, ...')
class Edition < ActiveRecord::Base

  ##
  # Validate if the edition as a name -> year
  #
  # @return [Date]
  validates :year, :presence => true

  ##
  # Validate if the dates are coherent
  validate :dates_are_okay?

  # Association macros

  ##
  # Get the associated agegroups
  #
  # @ return [Agegroup]
  has_many :agegroups

  ##
  # Get the associated registrations from this editions
  #
  # @ return [Registration]
  has_many :registrations

  ##
  # Utility method to validate if the dates of chronological
  #
  # @ return [Boolean]
  def dates_are_okay?
    return self.end_date > self.start_date
  end
end
