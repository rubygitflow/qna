module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def rating
    votes.sum(:status)
  end

  def create_positive_vote(user)
    votes.create_with(status: 1).find_or_create_by(user_id: user.id)
  end

  def create_negative_vote(user)
    votes.create_with(status: -1).find_or_create_by(user_id: user.id)
  end
end