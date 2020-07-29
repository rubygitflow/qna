class ApplicationController < ActionController::Base

  def set_gon_user_id
    gon.user_id = current_user&.id
  end

end
