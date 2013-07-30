##
# This class represents the data from contactinfos table in database.
# Contains all the contactinfos from the users and schools
class Contactinfo < ActiveRecord::Base

  ##
  # Contactinfo needs to have a telephone
  #
  # @return [String]
  validates :telephone,  :length =>  { :maximum => 16 }

  ##
  # Contactinfo needs to have an address
  #
  # @return [String]
  validates :address, :address2, :province , :length =>  { :maximum => 128 }

  ##
  # Contactinfo needs to have a postal code
  #
  # @return [String]
  validates :postal_code, :length =>  { :maximum => 6 }

  ##
  # Get all the users with this contactinfo
  #
  # @return [User]
  has_many :users

  ##
  # Get all the schools with this contacinfo
  #
  # @return [School]
  has_many :schools

  ##
  # Get the associated city
  #
  # @return [City]
  belongs_to :city

  accepts_nested_attributes_for :city, allow_destroy: true


  ##
  # Utility method to concatenated contactinfo information to print
  #
  # @return [String]
  def full_address
    address + ", " + city.name + ", QC, " + postal_code + "  tel:" + telephone
  end
end
