class Composer < ActiveRecord::Base

  # Association macros
  has_many :pieces

  # Attributes
  attr_accessible :name

end
