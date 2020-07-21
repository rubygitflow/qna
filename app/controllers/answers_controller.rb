class AnswersController < ApplicationController
  layout :false, only: %i[create update destroy select_best]
  before_action :authenticate_user!, except: :show
  before_action :find_question, only: %i[index create show]
  before_action :load_answer, only: %i[show edit update destroy select_best]
  before_action :check_answer_author, only: %i[update destroy]
  before_action :check_question_author, only: :select_best

  def index
    @answers = @question.answers
  end

  def show
    @answer = @question.answers.build
    @answer.links.build
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
    @answer.destroy
  end

  def select_best
    @answer.select_best!
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [],
                                   links_attributes: [:name, :url])
  end

  def check_question_author
    unless current_user.author?(@answer.question)
      head(:forbidden)
    end
  end

  def check_answer_author
    unless current_user.author?(@answer)
      head(:forbidden)
    end
  end

end
