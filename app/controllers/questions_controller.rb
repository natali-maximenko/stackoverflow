class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, only: [:new, :create]
  before_action :find_question, only: [:show, :update, :destroy]
  before_action :check_user, only: [:update, :destroy]
  after_action :publish_question, only: [:create]

  def index
    @questions = Question.all 
  end
  
  def show
    @answer = Answer.new
    @answers = @question.answers.sorted_best
    @answer.links.new
  end

  def new
    @question = Question.new
    @question.links.new
    @question.build_reward
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
    @question = Question.with_attached_files.find(params[:id])
    gon.question_id = @question.id
    gon.question_user_id = @question.user_id
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:name, :url], reward_attributes: [:name, :file])
  end

  def check_user
    unless current_user.author_of?(@question)
      redirect_to root_path, notice: 'Access denied'
    end
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast('questions', question: @question)
  end
end
