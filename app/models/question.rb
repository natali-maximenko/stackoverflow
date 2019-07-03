class Question < ApplicationRecord
  attr_accessor :best_answer

  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true

  def best_answer
    Answer.find_by(id: self.answer_id)
  end

  def best_answer=(value)
    update(answer_id: value.id) 
  end

  def sorted_by_best_answers
    without_best = answers.reject { |answer| answer.id == self.answer_id }
    [best_answer] + without_best
  end 
end
