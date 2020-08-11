class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: %i[index create]
  before_action :set_answer, only: %i[show update destroy]

  authorize_resource

  def index
    render json: @question.answers
  end

  def show
    render json: @answer, serializer: AnswerShowSerializer
  end

  def create
    @answer = @question.answers.create!(
      answer_params.merge(user_id: current_resource_owner.id))
    render json: @answer, status: :created
  end

  def update
    @answer.update(answer_params)
    render json: @answer, status: :ok
  end

  def destroy
    @answer.destroy
    head :no_content
  end


  private

  def answer_params
    params.require(:answer).permit(
      :body,
      links_attributes: %i[name url]
    )
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end
end
