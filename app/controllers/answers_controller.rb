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
    @answer = @question.answers.new(answer_params.merge(user_id: current_user.id))

    if @answer.save
      redirect_to @answer.question, notice: 'Your answer added'
    else
      render 'questions/show'
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to @answer
    else
      render :edit
    end
  end

  def destroy
    unless current_user.author?(@answer)
      return redirect_to @answer.question, notice: 'Delete unavailable! You are not the author of the answer.'
    end

    @answer.destroy
    redirect_to @answer.question, notice: 'Answer was successfully deleted.'
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
