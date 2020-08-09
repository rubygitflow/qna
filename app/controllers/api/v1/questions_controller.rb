class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource class: Question

  def index
    @questions = Question.order(:created_at)
    render json: @questions
  end
end
