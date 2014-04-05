class Ability
  include CanCan::Ability

  def initialize(user)
   user ||= User.new
   #user ||= User.current || User.new
   can :manage, :all if user.is_admin?

   can :read, Blog::Post
   can :create, Blog::Post if user.persisted? && user.is_blogger?
   can :edit, Blog::Post, user: user if user.persisted? && user.is_blogger?
   can :destroy, Blog::Post, user: user if user.persisted? && user.is_blogger?

   can :manage, Blog::Comment, post: {user: user} if user.persisted? && user.is_blogger?
   can :read, Blog::Comment
   can :create, Blog::Comment if user.persisted?
   can :edit, Blog::Comment, commenter: user if user.persisted?
   can :destroy, Blog::Comment, commenter: user if user.persisted?
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
