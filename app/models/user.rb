class User < ActiveRecord::Base
  validates :last_name, :first_name ,:length => {maximum: 64}, :presence => true
  validates :birthday, :presence => true
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

  # Include default devise modules.
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :confirmable, :lockable

  # Scopes
  scope :with_role, lambda{ |role| joins(:roles).where(:roles => {:name => role}) }

  ## Validates
  #validates :first_name, :presence => true
  #validates :last_name, :presence => true
  #validates :birthday, :presence => true

  # Class methods
  def self.participants
    User.with_role('Participant')
  end

  def self.accompanists
    User.with_role('Accompagnateur')
  end

  def self.teachers
    User.with_role('Professeur')
  end

  def self.juges
    User.joins(:roles).where(:roles_users => {:confirmed => true}, :roles => {:name => 'Juge'})
  end

  def self.unconfirmed_juges
    User.joins(:roles).where(:roles_users => {:confirmed => false}, :roles => {:name => 'Juge'})
  end

  def self.admins
    User.with_role('Administrateur')
  end

  # Instance methods
  def has_role?(role_sym)
    roles.any? { |r| (r.name.to_s.capitalize == role_sym.to_s.capitalize) }
  end

  def is_admin?
    return self.has_role?('Administrateur')
  end

  def is_judge?
    return (self.has_role?('Juge') && RolesUser.where("role_id=#{Role.find_by_name('Juge').id} and user_id=#{self.id}").first.confirmed)
  end

  def is_participant?
    return self.has_role?('Participant')
  end

  def is_accompanist?
    return self.has_role?('Accompagnateur')
  end

  def is_teacher?
    return self.has_role?('Professeur')
  end

  def name
    self.first_name + " " + self.last_name
  end

  def age
    now = Time.now.utc.to_date
    now.year - self.birthday.year - ((now.month > self.birthday.month || (now.month == self.birthday.month && now.day >= self.birthday.day)) ? 0 : 1)
  end
end
