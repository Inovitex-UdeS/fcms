class Contactinfo < ActiveRecord::Base
  validates :telephone,  :length =>  { :maximum => 16 }
  validates :address, :address2, :province , :length =>  { :maximum => 128 }
  validates :postal_code, :length =>  { :maximum => 6 }

  # Association macros
  has_many :users
  has_many :schools

  belongs_to :city

  accepts_nested_attributes_for :city, allow_destroy: true


  def full_address
    address + ", " + city.name + ", QC, " + postal_code + "  tel:" + telephone
  end
end
