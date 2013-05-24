class School < ActiveRecord::Base

  # Association macros
  has_many :registrations

  belongs_to :schoolboard

end
