class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, User

    return unless user

    can [:update, :finish_sign_up], User, id: user.id
  end
end
