##
# This class represents the data from categories table in database.
# Contains all the categories in application ('Répertoire, Musique Canadienne, ...')
class Category < ActiveRecord::Base

  ##
  # Agegroup requires an edition to be created
  #
  # @ return [String]
  validates :name, :presence => true,  :uniqueness => true,  :length =>  { :maximum => 128 }

  ##
  # Get the associated age groups of this category
  #
  # @ return [Agegroup]
  has_many :agegroups

  ##
  # Get the associated Registrations of this category
  #
  # @ return [Registration]
  has_many :registrations

  ##
  # Get the associated Timeslots of this category
  #
  # @ return [Timeslot]
  has_many :timeslots

end
