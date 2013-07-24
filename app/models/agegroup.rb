class Agegroup < ActiveRecord::Base
  validates :edition_id, :presence => true
  validates :category_id, :presence => true
  validates :description, :length =>  { :maximum => 128 }



  # Association macros
  belongs_to :category
  belongs_to :edition

end
