class Agegroup < ActiveRecord::Base

  # Association macros
  belongs_to :category
  belongs_to :edition

end
