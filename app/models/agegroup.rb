class Agegroup < ActiveRecord::Base
  #associations
  belongs_to :category
  belongs_to :edition

end
