class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    auth_authentication
  end

  def facebook
    auth_authentication
  end

  private

  def auth_authentication
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: action_name.capitalize) if is_navigational_format?
    else
      redirect_to root_path, alert: t('.failure')
    end
  end
end
