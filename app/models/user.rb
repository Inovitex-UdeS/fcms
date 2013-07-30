##
# This class represents the data from users table in database.
# It contains all required information needed for devise, validates and helper methods.
class User < ActiveRecord::Base

  ##
  # First_name and last_name are required when creating a user
  validates :last_name, :first_name ,:length => {maximum: 64}, :presence => true

  ##
  # Birthday is required when creating a user (to be able to match him in an [Agegroup])
  validates :birthday, :presence => true

  ##
  # First_name and last_name are required when creating a user (unique id for user, will connect with it)
  validates :email, :presence => true, :uniqueness => true

  # Association macros
  has_many :payments
  has_many :roles_users
  has_many :registrations_users
  has_many :roles, :through => :roles_users
  has_many :instruments, :through => :registrations_users
  has_many :registrations, :through => :registrations_users

  belongs_to :contactinfo
  belongs_to :school

  accepts_nested_attributes_for :contactinfo, :allow_destroy => true

  ##
  # Devise need all of this to perform authentication
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :confirmable, :lockable

  ##
  # Utility method to find all user with a specified role
  #
  # @params [String]
  #  The role we want to search. Example: Juge, Administrateur, Participant, ...
  #
  # @return [User]
  #  Will return an array of User models with the specific role
  #
  # @example
  #  User.with_role("Administrateur") #=> array of User models
  scope :with_role, lambda{ |role| joins(:roles).where(:roles => {:name => role}) }

  ##
  # Find all the participants registered to website
  #
  # @return [User]
  #  Will return an array of User models with participant role
  def self.participants
    User.with_role('Participant')
  end

  ##
  # Find all the accompanists registered to website
  #
  # @return [User]
  #  Will return an array of User models with accompanist role
  def self.accompanists
    User.with_role('Accompagnateur')
  end

  ##
  # Find all the teachers registered to website
  #
  # @return [User]
  #  Will return an array of User models with teacher role
  def self.teachers
    User.with_role('Professeur')
  end

  ##
  # Find all the juges registered to website (they need to be confirmed)
  #
  # @return [User]
  #  Will return an array of User models with juge role
  def self.juges
    User.joins(:roles).where(:roles_users => {:confirmed => true}, :roles => {:name => 'Juge'})
  end

  ##
  # Find all the unconfirmed juges registered to website
  #
  # @return [User]
  #  Will return an array of User models with juge role
  def self.unconfirmed_juges
    User.joins(:roles).where(:roles_users => {:confirmed => false}, :roles => {:name => 'Juge'})
  end

  ##
  # Find all the unconfirmed administrators registered to website
  #
  # @return [User]
  #  Will return an array of User models with administrator role
  def self.admins
    User.with_role('Administrateur')
  end

  ##
  # Utility method to find if the user has the role
  #
  # @return [TrueClass, FalseClass]
  #  Will return true if user has the role and false otherwise
  #
  # @example
  #  User.find(1).has_role?('Juge')
  def has_role?(role_sym)
    roles.any? { |r| (r.name.to_s.capitalize == role_sym.to_s.capitalize) }
  end

  ##
  # Find if the user is admin
  #
  # @return [Boolean]
  #  Will return true if user has the role administrator
  def is_admin?
    return self.has_role?('Administrateur')
  end

  ##
  # Find if the user is juge
  #
  # @return [Boolean]
  #  Will return true if user has the role juge and is confirmed
  def is_judge?
    return (self.has_role?('Juge') && RolesUser.where("role_id=#{Role.find_by_name('Juge').id} and user_id=#{self.id}").first.confirmed)
  end

  ##
  # Find if the user is participant
  #
  # @return [TrueClass, FalseClass]
  #  Will return true if user has the role participant
  def is_participant?
    return self.has_role?('Participant')
  end

  ##
  # Find if the user is accompanist
  #
  # @return [TrueClass, FalseClass]
  #  Will return true if user has the role accompanist
  def is_accompanist?
    return self.has_role?('Accompagnateur')
  end

  ##
  # Find if the user is a teacher
  #
  # @return [TrueClass, FalseClass]
  #  Will return true if user has the role teacher
  def is_teacher?
    return self.has_role?('Professeur')
  end

  ##
  # Utility method to concatenate first_name and last_name
  #
  # @return [TrueClass, FalseClass]
  #  Will return the concatenated string
  def name
    self.first_name + " " + self.last_name
  end

  ##
  # Utility method to calculate age of the user. This is done by calculating (time.now-birthday)
  # It was not as simple in ruby, so here is the answer: [StackOverflow answer](http://stackoverflow.com/a/2357790)
  #
  # @return [Integer]
  #  Will return the age of the user
  def age
    now = Time.now.utc.to_date
    now.year - self.birthday.year - ((now.month > self.birthday.month || (now.month == self.birthday.month && now.day >= self.birthday.day)) ? 0 : 1)
  end
end
