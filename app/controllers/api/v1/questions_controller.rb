class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: %i[show update destroy]

  authorize_resource

  def index
    @questions = Question.order(:created_at)
    render json: @questions
  end

  def show
    render json: @question, serializer: QuestionShowSerializer
  end

  def create
    @question = current_resource_owner.questions.create!(question_params)
    render json: @question, status: :created
  end

  def update
    @question.update(question_params)
    render json: @question, status: :ok
  end

  def destroy
    @question.destroy
    head :no_content
  end

  private

  def question_params
    params.require(:question).permit(
      :title, 
      :body,
      links_attributes: %i[name url]
    )
  end

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end
end
