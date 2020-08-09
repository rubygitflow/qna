class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  private

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :me, User
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer], user_id: user.id
    can :destroy, Comment do |comment|
      user.id == comment.user.id
    end    
    can :destroy, ActiveStorage::Attachment do |attachment|
      user.author?(attachment.record)
    end
    can :destroy, Link do |link|
      user.author?(link.linkable)
    end
    can :select_best, Answer, user_id: user.id
    can [:up, :down], [Question, Answer] do |resource|
      !user.author?(resource)
    end
    can :cancel_vote, [Question, Answer]
  end
end