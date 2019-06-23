class AnswersController < ApplicationController

  def index
    @answers = question.answers
  end
  
  def new; end
  
  def create
    @answer = question.answers.build(answer_params)
  
    if @answer.save
      redirect_to question_answers_url(question)
    else
      render :new
    end
  end
  
  def show; end
  
  private
  
  def question
    @question ||= Question.find(params[:question_id])
  end
  
  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end
  
  def answer_params
    params.require(:answer).permit(:body)
  end    
end
