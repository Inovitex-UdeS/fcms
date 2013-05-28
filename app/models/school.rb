class School < ActiveRecord::Base

  # Association macros
  has_many :registrations

  belongs_to :schooltype
  belongs_to :schoolboard
  belongs_to :contactinfo

end
