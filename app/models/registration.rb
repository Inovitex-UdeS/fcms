##
# This class represents the data from registrations table in database.
# Contains all the registrations in the application (all editions)
class Registration < ActiveRecord::Base

  ##
  # Owner, teacher, edition, category and duration are required
  #
  # @ return [String]
  validates :user_owner_id, :user_teacher_id, :edition_id, :category_id, :duration, :presence => true

  ##
  # Directly get the performances from the registration
  #
  # @ return [Performance]
  has_many :performances

  ##
  # Directly get the association [Registration] and [User]
  #
  # @ return [RegistrationsUser]
  has_many :registrations_users

  ##
  # Directly get the instruments from the registration
  #
  # @ return [Instrument]
  has_many :instruments, :through => :registrations_users

  ##
  # Directly get the users from the registration
  #
  # @ return [User]
  has_many :users, :through => :registrations_users

  ##
  # Directly get the pieces from the performances of the registration
  #
  # @ return [Piece]
  has_many :pieces, :through => :performances

  ##
  # Directly get the composers from the pieces from the performances of the registration
  #
  # @ return [Composer]
  has_many :composers, :through => :pieces

  ##
  # Directly get the composers from the pieces from the performances of the registration
  #
  # @ return [Composer]
  belongs_to :category

  ##
  # Get the edition of the registration
  #
  # @ return [Edition]
  belongs_to :edition

  ##
  # Get the owner of the registration
  #
  # @ return [User]
  belongs_to :owner, :class_name => 'User', :foreign_key => 'user_owner_id'

  ##
  # Get the teacher of the registration
  #
  # @ return [Teacher]
  belongs_to :teacher,:class_name => 'User', :foreign_key => 'user_teacher_id'

  ##
  # Get the accompanist of the registration
  #
  # @ return [Accompanist]
  belongs_to :accompanist,:class_name => 'User', :foreign_key => 'user_accompanist_id'

  ##
  # Get the school of the registration
  #
  # @ return [School]
  belongs_to :school

  ##
  # Get the timeslot of the registration
  #
  # @ return [Timeslot]
  belongs_to :timeslot

 # Nested attributes
  accepts_nested_attributes_for :performances, allow_destroy: true
  accepts_nested_attributes_for :users, allow_destroy: true
  accepts_nested_attributes_for :instruments, allow_destroy: true
  accepts_nested_attributes_for :registrations_users, allow_destroy: true


  ##
  # Format registration in JSON for planification form
  # Contains all [RegistrationsUser] and all [Performance] from the [Registration]
  #
  # @ return [Json]
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

  ##
  # Format registration in JSON for planification form
  #
  # @ return [Json]
  def print_instruments
    instruments_string = '';
    self.instruments.each { |inst| instruments_string += inst.name + '<br>'}
    return instruments_string
  end

  ##
  # Format registration in JSON for planification form
  #
  # @ return [Json]
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

  ##
  # Format a string containing all the pieces for dataTables
  #
  # @ return [String]
  def print_pieces
    pieces_string = '';
    self.pieces.each { |piece| pieces_string += piece.title + '<br>' }
    return pieces_string
  end

  ##
  # Format a string containing all the composers for dataTables
  #
  # @ return [String]
  def print_composers
    composers_string = '';
    self.composers.each { |comp| composers_string += comp.name + '<br>' }
    return composers_string
  end

  ##
  # Format the accompanist label as a string for select2 (hack in the registration view)
  #
  # @ return [String]
  def print_accompanist_name
    if self.accompanist
      self.accompanist.first_name + ' ' + self.accompanist.last_name + ' (' + self.accompanist.email + ')'
    else
      return ''
    end
  end

  ##
  # Format the accompanist id as a string for select2 (hack in the registration view)
  #
  # @ return [String]
  def print_accompanist_id
    if self.accompanist
      self.accompanist.id.to_s
    else
      return ''
    end
  end

  ##
  # Format the teacher label as a string for select2 (hack in the registration view)
  #
  # @ return [String]
  def print_teacher_name
    if self.teacher
      return self.teacher.first_name + ' ' + self.teacher.last_name + ' (' + self.teacher.email + ')'
    else
      return ''
    end
  end

  ##
  # Format the teacher id as a string for select2 (hack in the registration view)
  #
  # @ return [String]
  def print_teacher_id
    if self.teacher
      return self.teacher.id.to_s
    else
      return ''
    end
  end

end




