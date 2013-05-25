class Registration < ActiveRecord::Base

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

end
