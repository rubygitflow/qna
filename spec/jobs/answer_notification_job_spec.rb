require 'rails_helper'

RSpec.describe AnswerNotificationJob, type: :job do
  let(:answer) { create(:answer) }

  it 'calls Answer Notification' do
    expect(AnswerNotification).to receive(:send_create_notification).with(answer)
    AnswerNotificationJob.perform_now(answer)
  end
end
