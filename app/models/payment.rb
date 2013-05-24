class Payment < ActiveRecord::Base

  # Association macros
  belongs_to :registration
  belongs_to :user

end
