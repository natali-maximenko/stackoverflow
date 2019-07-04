class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user 
  
  validates :body, presence: true

  scope :sorted_best, -> { order(best: :desc) }

  def make_best
    ActiveRecord::Base.transaction do
      old_best_answer = question.best_answer
      old_best_answer.update!(best: false) if old_best_answer
      update!(best: true)
    end
  end
end
