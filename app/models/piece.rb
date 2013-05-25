class Piece < ActiveRecord::Base

  # Association macros
  has_many :performances

  belongs_to :composer

end
