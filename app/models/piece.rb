##
# This class represents the data from pieces table in database.
# Contains all the pieces from the tools/piece.csv from [http://imslp.org/]
class Piece < ActiveRecord::Base

  ##
  # Piece needs to have a composer in order to create it
  #
  # @ return [Integer]
  validates :composer_id, :presence => true

  ##
  # Piece needs to have a title in order to create it
  #
  # @ return [String]
  validates :title, :presence => true, :length => { maximum: 128}

  ##
  # Get all the performances with the piece
  #
  # @ return [Performance]
  has_many :performances

  ##
  # Get the composer of the piece
  #
  # @ return [Composer]
  belongs_to :composer

end
