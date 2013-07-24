class City < ActiveRecord::Base
  validates :name, :presence => true,  :uniqueness => true,  :length =>  { :maximum => 64 }

  # Association macros
  has_many :contactinfo

end
