class RegistrationsUser < ActiveRecord::Base
  validates :instrument_id, :registration_id, :user_id, :presence => true

  # Associations marcos
  belongs_to :instrument
  belongs_to :registration
  belongs_to :user

end
