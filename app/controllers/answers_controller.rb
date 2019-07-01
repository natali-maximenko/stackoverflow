class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [ :create ]
  before_action :find_question, only: [:create]
  before_action :find_answer, only: [:destroy]
  before_action :check_user, only: [:destroy]
  
  def create
    @answer = @question.answers.build(answer_params.merge(user: current_user))
  
    if @answer.save
      redirect_to question_path(@question), notice: 'Your answer successfully created.'
    else
      render 'questions/show'
    end
  end

  def destroy
    @answer.destroy
    redirect_to @answer.question, notice: 'Your answer successfully destroyed.'
  end
  
  private
  
  def find_question
    @question = Question.find(params[:question_id])
  end
  
  def find_answer
    @answer = params[:id] ? Answer.find(params[:id]) : Answer.new
  end
  
  def answer_params
    params.require(:answer).permit(:body)
  end

  def check_user
    unless current_user.author_of?(@answer)
      redirect_to root_path, notice: 'Access denied'
    end
  end
end
