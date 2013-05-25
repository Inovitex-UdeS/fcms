class RegistrationsUser < ActiveRecord::Base

  # Associations marcos
  belongs_to :instrument
  belongs_to :registration
  belongs_to :user

end
