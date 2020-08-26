class FindForOauth
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user if authorization

    email = auth.info[:email]
    if email.blank?
      uid = auth.uid.to_s
      remoute_user = Authorization.find_by(uid: uid)
      puts "user=#{remoute_user.inspect}"
      if remoute_user.present?
        user = User.find(remoute_user.user_id)
        email = user.email
      else
        return nil
      end
    else
      user = User.find_by(email: email)
    end

    if user
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, confirmed_at: Time.now)
      user.create_authorization(auth)
    end

    user
  end
end
