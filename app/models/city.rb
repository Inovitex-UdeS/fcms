class City < ActiveRecord::Base

  # Association macros
  has_many :contactinfo

end
