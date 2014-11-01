class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, User

    return unless user

    can [:update, :finish_sign_up], User, id: user.id

    can :create, Pledge if user.sign_up_complete?
  end
end
