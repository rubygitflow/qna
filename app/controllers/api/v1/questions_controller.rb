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
    @question = current_resource_owner.questions.new(question_params)
    if @question.save
      render json: @question, status: :created
    else
      render json: {errors: @question.errors}, status: :unprocessable_entity
    end 
  end

  def update
    if @question.update(question_params)
      render json: @question, status: :ok
    else
      render json: {errors: @question.errors}, status: :unprocessable_entity
    end 
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
