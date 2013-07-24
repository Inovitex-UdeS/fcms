class Category < ActiveRecord::Base
  validates :name, :presence => true,  :uniqueness => true,  :length =>  { :maximum => 128 }

  # Association macros
  has_many :agegroups
  has_many :registrations
  has_many :timeslots

end
