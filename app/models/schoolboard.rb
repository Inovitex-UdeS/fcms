##
# This class represents the data from schoolboards table in database.
# Contains all schoolboards in Estrie (like 'Commission scolaire des Sommets, Commission scolaire de la Région-de-Sherbrooke, ....')
class Schoolboard < ActiveRecord::Base

  ##
  # Name of the schoolboard is required in order to create it
  #
  # @ return [String]
  validates :name, :presence => true, :length => { :maximum => 128}, :uniqueness => true

  ##
  # Get the associated schools
  #
  # @ return [School]
  has_many :schools

end


