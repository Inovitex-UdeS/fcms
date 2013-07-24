class School < ActiveRecord::Base
  validates :schooltype_id, :schoolboard_id, :presence => true
  validates :name, :presence => true, :length => { :maximum => 128}, :uniqueness => true


  # Association macros
  has_many :registrations

  belongs_to :schooltype
  belongs_to :schoolboard
  belongs_to :contactinfo

  accepts_nested_attributes_for :contactinfo, :allow_destroy => true
end
