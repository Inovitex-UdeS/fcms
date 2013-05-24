class Piece < ActiveRecord::Base

  # Association macros
  has_many :performances

  belongs_to :composer

  # Attributes
  attr_accessible :title, :composer_id

end
