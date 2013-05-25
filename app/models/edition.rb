class Edition < ActiveRecord::Base

  # Association macros
  has_many :agegroups
  has_many :registrations

end
