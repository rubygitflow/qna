class Answer < ApplicationRecord
  include Authorable
  include Votable
  include Commentable
  
  belongs_to :question, touch: true

  has_many_attached :files
  has_many :links, dependent: :destroy, as: :linkable
  
  validates :body, presence: true 

  accepts_nested_attributes_for :links, reject_if: :all_blank

  after_create :send_notification

  def select_best!
    Answer.transaction do
      question.answers.update_all(best:false)
      question.reward&.update!(user_id: user_id)
      update!(best: true)
    end
  end
  
  private

  def send_notification
    AnswerNotificationJob.perform_later(self)
  end
end
