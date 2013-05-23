class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:

       user ||= User.new  # guest user (not logged in)
       if user.has_role?(:administrateur)
         can :dostuff, :all
       else#if user.has_role?(:professeur)
         can :read, :all
         can :dostuff, User
       end
  end
end
