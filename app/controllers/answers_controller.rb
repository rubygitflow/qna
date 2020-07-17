class AnswersController < ApplicationController
  layout :false, only: %i[create update destroy select_best]
  before_action :authenticate_user!, except: :show
  before_action :find_question, only: %i[index create]
  before_action :load_answer, only: %i[show edit update destroy select_best]

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
  end


  def update
    @answer.update(answer_params)
  end

  def destroy
    @answer.destroy if current_user.author?(@answer)
  end

  def select_best
    @answer.select_best! if current_user.author?(@answer.question)
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
