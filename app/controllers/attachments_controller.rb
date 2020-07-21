class AttachmentsController < ApplicationController
  layout :false, only: %i[destroy]
  before_action :authenticate_user!

  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    @attachment.purge if current_user.author?(@attachment.record)
  end
end
