##
# This class represents the data from schools table in database.
# Contains all schools in Estrie (like 'Séminaire de Sherbrooke, Cégep de Sherbrooke, ....')
class School < ActiveRecord::Base

  ##
  # Type of the school and schoolboard are required in order to create it
  #
  # @ return [Integer]
  validates :schooltype_id, :schoolboard_id, :presence => true

  ##
  # Name of the school is required in order to create it
  #
  # @ return [String]
  validates :name, :presence => true, :length => { :maximum => 128}, :uniqueness => true


  ##
  # Get the registrations associated with the school
  #
  # @ return [Registration]
  has_many :registrations

  ##
  # Get the schooltype of the school
  #
  # @ return [Schooltype]
  belongs_to :schooltype

  ##
  # Get the schoolboard of the school
  #
  # @ return [Schooltype]
  belongs_to :schoolboard

  ##
  # Get the contact of the school
  #
  # @ return [Schooltype]
  belongs_to :contactinfo

  accepts_nested_attributes_for :contactinfo, :allow_destroy => true
end
