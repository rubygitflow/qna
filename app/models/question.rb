class Question < ApplicationRecord
  include Authorable
  include Votable
  include Commentable
  
  # https://guides.rubyonrails.org/association_basics.html
  # https://apidock.com/rails/ActiveRecord/Associations/ClassMethods/has_many
  has_many :answers, -> { order('best DESC, created_at') }, dependent: :destroy
  has_many_attached :files
  has_many :links, dependent: :destroy, as: :linkable
  has_many :subscriptions, dependent: :destroy
  has_one :reward, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  after_create :calculate_reputation
  after_create :create_subscription

  scope :created_prev_day, -> { where(created_at: Date.today.prev_day.all_day) }
    
  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
  
  def create_subscription
    user.subscriptions.find_or_create_by(question_id: id)
  end
end
