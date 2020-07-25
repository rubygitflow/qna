module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def rating
    # votes.sum(:status ? 1 : -1)
    pos = votes.count(:status, :conditions => ['status = ?', :true])
    neg = votes.count(:status, :conditions => ['status = ?', :false])
    pos - neg
  end

  def create_positive_vote(user_id)
    puts "create_positive_vote"
    votes.create_with(status: true).find_or_create_by(user_id: user_id)
  end

  def create_negative_vote(user_id)
    puts "create_negative_vote"
    votes.create_with(status: false).find_or_create_by(user_id: user_id)
  end
end