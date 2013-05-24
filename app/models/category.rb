class Category < ActiveRecord::Base

  # Association macros
  has_many :agegroups
  has_many :registrations

  # Attributes
  attr_accessible :name, :nb_perf_min, :nb_perf_max, :description

end
