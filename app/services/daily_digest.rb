class DailyDigest
  def send_digest
  	return if Question.created_prev_day.empty?
  	
    User.find_each(batch_size: 500) do |user|
      DailyDigestMailer.digest(user).deliver_later
    end
  end
end
