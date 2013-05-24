class Payment < ActiveRecord::Base

  # Association macros
  belongs_to :registration
  belongs_to :user

  # Attributes
  attr_accessible :mode, :no_chq, :name_chq , :date_chq, :depot_date, :invoice, :cash,
                  :registration_id, :user_id

end
