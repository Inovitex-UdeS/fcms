class Agegroup < ActiveRecord::Base

  # Association macros
  belongs_to :category
  belongs_to :edition

  # Attributes
  attr_accessible :min, :max, :fee, :max_duration

end
