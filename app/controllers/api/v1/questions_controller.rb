class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource

  def index
    @questions = Question.order(:created_at)
    render json: @questions
  end

  def show
    @question = Question.with_attached_files.find(params[:id])
    render json: @question, serializer: QuestionShowSerializer
  end

end
