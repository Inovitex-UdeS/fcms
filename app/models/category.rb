class Category < ActiveRecord::Base
  #associations
  has_many :agegroup
  has_many :registration
end
