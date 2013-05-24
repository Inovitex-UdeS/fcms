class Agegroup < ActiveRecord::Base
  attr_accessible :min, :max, :description, :fee, :max_duration

  #relations
  belongs_to :category
  belongs_to :edition
end
