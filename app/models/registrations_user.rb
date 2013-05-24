class RegistrationsUser < ActiveRecord::Base

  # Associations marcos
  belongs_to :instrument
  belongs_to :registration
  belongs_to :user

  # Attributes
  attr_accessible :instrument_id, :registration_id, :user_id

end
