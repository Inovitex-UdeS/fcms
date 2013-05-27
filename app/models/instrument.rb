class Instrument < ActiveRecord::Base

  # Association macros
  has_many :registrations_users
  has_many :users, :through => :registrations_users
  has_many :registrations, :through => :registrations_users

end
