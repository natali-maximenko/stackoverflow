class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, only: [ :create ]
  before_action :find_question, only: [:create]
  before_action :find_answer, only: [:update, :best, :destroy]
  before_action :check_user, only: [:update,  :destroy]
  before_action :question_owner, only: [:best]
  after_action :publish_answer, only: [:create]
  
  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer.destroy
  end

  def best
    @question = @answer.question
    @answer.make_best
  end
  
  private
  
  def find_question
    @question = Question.find(params[:question_id])
  end
  
  def find_answer
    @answer = params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new
  end
  
  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end

  def check_user
    unless current_user.author_of?(@answer)
      redirect_to root_path, notice: 'Access denied'
    end
  end

  def question_owner
    unless current_user.author_of?(@answer.question)
      redirect_to root_path, notice: 'Access denied'
    end
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
        "answers_question_#{@question.id}",
        answer: @answer,
        links: @answer.links,
        rating: @answer.rating
    )
  end
end
