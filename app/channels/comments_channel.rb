class CommentsChannel < ApplicationCable::Channel
  def follow_comments(data)
    stream_from "questions_#{data['question_id']}_comments"
  end
end
