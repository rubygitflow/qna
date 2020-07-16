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
    @answer = @question.answers.new(answer_params)

    if @answer.save
      redirect_to @question
    end
  end


  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    if current_user.author?(@answer)
      @answer.destroy
      redirect_to @answer.question, notice: 'Answer was successfully deleted.'
    else
      return redirect_to @answer.question, notice: 'Delete unavailable! You are not the author of the answer.'
    end

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
