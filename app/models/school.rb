class School < ActiveRecord::Base

  # Association macros
  has_many :registrations

  belongs_to :schoolboard

  # Attributes
  attr_accessible :name, :telephone, :address, :city, :province, :postal_code, :schoolboard_id

end
