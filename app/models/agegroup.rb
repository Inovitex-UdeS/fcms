##
# This class represents the data from agegroups table in database.
# Contains all the agegroups in application ('8 à 10 ans, 10 à 12 ans, ...')
class Agegroup < ActiveRecord::Base
  ##
  # Agegroup requires an edition to be created
  #
  # @ return [String]
  validates :edition_id, :presence => true

  ##
  # Agegroup requires a cateogry to be created
  #
  # @ return [Integer]
  validates :category_id, :presence => true

  ##
  # Agegroup requires a description to be created
  #
  # @ return [String]
  validates :description, :length =>  { :maximum => 128 }

  ##
  # Get the associated category
  #
  # @ return [Category]
  belongs_to :category

  ##
  # Get the associated edition
  #
  # @ return [Edition]
  belongs_to :edition

end
