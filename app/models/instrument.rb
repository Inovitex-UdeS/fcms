class Instrument < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true,  :length => { maximum: 64}

  # Association macros
  has_many :registrations_users
  has_many :users, :through => :registrations_users
  has_many :registrations, :through => :registrations_users

end
