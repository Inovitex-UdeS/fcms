class School < ActiveRecord::Base

  # Association macros
  has_many :registrations

  belongs_to :schooltype
  belongs_to :schoolboard
  belongs_to :contactinfo

  accepts_nested_attributes_for :contactinfo, :allow_destroy => true
end
