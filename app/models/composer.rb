class Composer < ActiveRecord::Base

  # Association macros
  has_many :pieces

  accepts_nested_attributes_for :pieces

end
