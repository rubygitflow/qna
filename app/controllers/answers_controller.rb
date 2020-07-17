class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :find_question, only: %i[index new create]
  before_action :load_answer, only: %i[show edit update destroy]

  def index
    @answers = @question.answers
  end

  def show
  end

  def new
    @answer = @question.answers.new
  end

  def edit
  end

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    @answer.save
    render layout: false
  end


  def update
    @answer.update(answer_params)
    render layout: false
  end

  def destroy
    @answer.destroy if current_user.author?(@answer)
    render layout: false
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
