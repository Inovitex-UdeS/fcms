class Contactinfo < ActiveRecord::Base

  # Association macros
  has_many :users
  has_many :schools

  belongs_to :city

  accepts_nested_attributes_for :city, allow_destroy: true


  def full_address
    address + ", " + city.name + ", QC, " + postal_code + "  tel:" + telephone
  end
end
