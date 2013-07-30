##
# This class represents the data from cities table in database.
# Contains all the cities in Estrie from eastern_cities.csv from [http://www.mamrot.gouv.qc.ca/repertoire-des-municipalites/fiche/region/05/]
class City < ActiveRecord::Base
  ##
  # City needs a name in order to create it
  #
  # @ return [String]
  validates :name, :presence => true,  :uniqueness => true,  :length =>  { :maximum => 64 }

  ##
  # Get the associated contactinfo
  #
  # @ return [ContactInfo]
  has_many :contactinfo

end
