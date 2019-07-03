class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :find_question, only: [:show, :update, :destroy]
  before_action :check_user, only: [:update, :destroy]

  def index
    @questions = Question.all 
  end
  
  def show
    @answer = Answer.new
    @answers = @question.sorted_by_best_answers
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new, question: @question
    end
  end

  def update
    @question.update(question_params) 
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Your question successfully destroyed.'
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def check_user
    unless current_user.author_of?(@question)
      redirect_to root_path, notice: 'Access denied'
    end
  end
end
