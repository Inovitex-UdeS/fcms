class Timeslot < ActiveRecord::Base
  validates :label, :edition_id, :category_id, :duration, :presence => true


  # attr_accessible :title, :body

  has_many :registrations

  ##
  # Custom serializer for timeslots, returning associated registrations as a simple array of IDs
  def as_json(options=nil)
    calculated_duration = 0
    regs = []
    registrations.each do |r|
      calculated_duration += r.duration
      regs << r.id
    end

    return {
        :id => id,
        :label => label,
        :created_at => created_at.strftime("%d/%m/%Y"),
        :duration => calculated_duration,
        :entered_duration => duration,
        :registrations => regs,
        :updated_at => updated_at.strftime("%d/%m/%Y")
    }.as_json
  end
end
