class AnswersChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "questions_#{data['question_id']}_answers"
  end
end
