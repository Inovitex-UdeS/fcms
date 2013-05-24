class School < ActiveRecord::Base
  has_many :registrations
  belongs_to :schoolboard

end
