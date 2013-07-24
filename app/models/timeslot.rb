class Timeslot < ActiveRecord::Base
  validates :label, :edition_id, :category_id, :duration, :presence => true


  # attr_accessible :title, :body

  has_many :registrations
end
