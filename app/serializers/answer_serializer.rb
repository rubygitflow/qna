class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :question_id, :body, :best, :created_at, :updated_at, :rating, :short_body
  belongs_to :user

  def short_body
    object.body.truncate(13)
  end
end
