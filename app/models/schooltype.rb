##
# This class represents the data from schooltypes table in database.
# Contains all school types of schools (like 'Secondaire, Primaire, ....')
class Schooltype < ActiveRecord::Base

  ##
  # Get the associated school
  #
  # @ return [School]
  has_many :school

end