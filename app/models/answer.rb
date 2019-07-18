class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  
  validates :body, presence: true

  scope :sorted_best, -> { order(best: :desc) }

  def make_best
    ActiveRecord::Base.transaction do
      old_best_answer = question.best_answer
      old_best_answer.update!(best: false) if old_best_answer
      update!(best: true)
      send_reward
    end
  end

  def send_reward
    question.reward&.update!(user: user)
  end
end
