class Edition < ActiveRecord::Base
  validates :year, :presence=>true
  validate :dates_are_okay?
  # Association macros
  has_many :agegroups
  has_many :registrations

  def dates_are_okay?
    return self.end_date > self.start_date
  end
end
