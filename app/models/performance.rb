##
# This class represents the data from performances table in database.
# Contains all the performances from all the registrations
class Performance < ActiveRecord::Base

  ##
  # A performance needs to have a piece in order to create it
  #
  # @ return [Integer]
  validates :piece_id, :presence => true

  ##
  # Get the associated [Piece]
  #
  # @ return [Piece]
  belongs_to :piece

  ##
  # Get the associated [Registration]
  #
  # @ return [Registration]
  belongs_to :registration

  accepts_nested_attributes_for :piece

end


