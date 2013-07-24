class Composer < ActiveRecord::Base
  validates :name, :presence => true,  :uniqueness => true,  :length =>  { :maximum => 128 }

  # Association macros
  has_many :pieces

  accepts_nested_attributes_for :pieces

end
