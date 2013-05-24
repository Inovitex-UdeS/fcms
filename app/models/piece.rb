class Piece < ActiveRecord::Base
  has_many :performances
  belongs_to :composer
end
