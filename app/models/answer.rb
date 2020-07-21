class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true 

  def select_best!
    Answer.transaction do
      question.answers.update_all(best:false)
      update!(best: true)
    end
  end
end
