class ApplicationController < ActionController::Base
  before_action :set_gon_user_id

  private

  def set_gon_user_id
    gon.user_id = current_user&.id
  end

end
