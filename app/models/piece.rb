class Piece < ActiveRecord::Base
  validates :composer_id, :presence => true
  validates :title, :presence => true, :length => { maximum: 128}

  # Association macros
  has_many :performances

  belongs_to :composer

end
