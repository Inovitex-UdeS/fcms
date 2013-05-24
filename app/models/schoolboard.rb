class Schoolboard < ActiveRecord::Base

  # Association macros
  has_many :schools

  # Attributes
  attr_accessible :name

end


