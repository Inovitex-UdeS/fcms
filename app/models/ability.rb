##
# NOT IMPLEMENTED
# This class is suppose to define all the permissions in the application

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:

       user ||= User.new  # guest user (not logged in)
       if user.has_role?(:administrateur)  # user.has_role?("Administrateur")
         can :dostuff, :all
         can :manage, :all
       else
         can :read, :all
       end
  end
end
