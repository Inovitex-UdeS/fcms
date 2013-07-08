class Timeslot < ActiveRecord::Base
  # attr_accessible :title, :body

  has_many :registrations
end
