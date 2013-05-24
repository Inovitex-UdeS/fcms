class Edition < ActiveRecord::Base

  # Association macros
  has_many :agegroups
  has_many :registrations

  # Attributes
  attr_accessible :year, :limit_date

end
