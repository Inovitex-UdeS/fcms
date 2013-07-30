##
# This class represents the data from composers table in database.
# Contains all the composers from the tools/composer.csv from [http://imslp.org/]
class Composer < ActiveRecord::Base
  ##
  # Composer needs a unique name in order to create it
  #
  # @ return [String]
  validates :name, :presence => true,  :uniqueness => true,  :length =>  { :maximum => 128 }

  ##
  # Get all the pieces from the composer
  #
  # @ return [String]
  has_many :pieces

  accepts_nested_attributes_for :pieces

end
