class School < ActiveRecord::Base
  attr_accessible :name, :telephone, :address, :address2, :city, :province, :postal_code

  has_many :registrations
  belongs_to :schoolboard

end
