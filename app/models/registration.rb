class Registration < ActiveRecord::Base
  validates :user_owner_id, :user_teacher_id, :edition_id, :category_id, :duration, :presence => true
  # Associations marcos

  has_many :performances
  has_many :registrations_users
  has_many :instruments, :through => :registrations_users
  has_many :users, :through => :registrations_users
  has_many :pieces, :through => :performances
  has_many :composers, :through => :pieces

  belongs_to :category
  belongs_to :edition
  belongs_to :owner, :class_name => 'User', :foreign_key => 'user_owner_id'
  belongs_to :teacher,:class_name => 'User', :foreign_key => 'user_teacher_id'
  belongs_to :accompanist,:class_name => 'User', :foreign_key => 'user_accompanist_id'
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

  def print_instruments
    instruments_string = '';
    self.instruments.each { |inst| instruments_string += inst.name + '<br>'}
    return instruments_string
  end

  def print_users
    users_string = '';
    users_string += '<b>' + self.owner.last_name + ', ' + self.owner.first_name + '</b> <br>'
    self.users.each do |user|
      if user.id == self.owner.id
        next
      end
      users_string += user.last_name + ', ' + user.first_name + '<br>'
    end
    return users_string
  end

  def print_pieces
    pieces_string = '';
    self.pieces.each { |piece| pieces_string += piece.title + '<br>' }
    return pieces_string
  end

  def print_composers
    composers_string = '';
    self.composers.each { |comp| composers_string += comp.name + '<br>' }
    return composers_string
  end


  def print_accompanist_name
    if self.accompanist
      self.accompanist.first_name + ' ' + self.accompanist.last_name + ' (' + self.accompanist.email + ')'
    else
      return ''
    end
  end

  def print_accompanist_id
    if self.accompanist
      self.accompanist.id.to_s
    else
      return ''
    end
  end

  def print_teacher_name
    if self.teacher
      return self.teacher.first_name + ' ' + self.teacher.last_name + ' (' + self.teacher.email + ')'
    else
      return ''
    end
  end
  def print_teacher_id
    if self.teacher
      return self.teacher.id.to_s
    else
      return ''
    end
  end

end




