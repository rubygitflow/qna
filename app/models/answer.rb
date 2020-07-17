class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true 

  def select_best!
    Answer.transaction do
      Answer.where(question_id: question_id).update_all(best: false)
      update!(best: true)
    end
  end
end
