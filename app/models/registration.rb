class Registration < ActiveRecord::Base
  validates :user_owner_id, :user_teacher_id, :edition_id, :category_id, :duration, :presence => true
  # Associations marcos

  has_many :performances
  has_many :registrations_users
  has_many :instruments, :through => :registrations_users
  has_many :users, :through => :registrations_users

  belongs_to :category
  belongs_to :edition
  belongs_to :owner, :class_name => 'User', :foreign_key => 'user_owner_id'
  belongs_to :teacher,:class_name => 'User', :foreign_key => 'user_teacher_id'
  belongs_to :school
  belongs_to :timeslot

 # Nested attributes
  accepts_nested_attributes_for :performances, allow_destroy: true
  accepts_nested_attributes_for :users, allow_destroy: true
  accepts_nested_attributes_for :instruments, allow_destroy: true
  accepts_nested_attributes_for :registrations_users, allow_destroy: true

  def as_simple_json
    reg_obj = {
        :category => category.name,
        :duration => duration,
        :age => age_max,
        :timeslot_id => timeslot_id,
        :users => [],
        :performances => []
    }

    registrations_users.each do |u|
      reg_obj[:users] << {
          :first_name => u.user.first_name,
          :last_name => u.user.last_name,
          :instrument => u.instrument.name
      }
    end

    performances.each do |p|
      reg_obj[:performances] << {
          :composer => p.piece.composer.name,
          :title => p.piece.title
      }
    end

    return reg_obj.as_json
  end
end
