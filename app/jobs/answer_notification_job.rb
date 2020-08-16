class AnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    AnswerNotification.send_create_notification(answer)
  end
end
